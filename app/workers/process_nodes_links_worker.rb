require 'wikipedia'

class ProcessNodesLinksWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'critical', retry: 10

  def perform(node_id)
    node = Node.find(node_id)

    if node.nil?
      puts "#{Time.zone.now}"
      puts "ERROR: Found a nil node from ProcessNodesLinksWorker!"
    else
      return if node.began_processing_links? or node.ended_processing_links?
      node.update_column(:began_processing_links, true)
      node.update_column(:error_processing_links, false)

      begin
        continue_query = nil
        while true
          query_options = {pllimit: 500}
          query_options.merge!({plcontinue: continue_query}) if continue_query

          wikipedia_content = Wikipedia.find(node.name, query_options)
          unless wikipedia_content.links.nil?
            wikipedia_content.links.each do |link_name|
              linked_node = Node.find_or_create_by_name(link_name, node.graph)
              Edge.find_or_create_from_nodes(node, linked_node, node.graph)
            end
          end

          continue_query = wikipedia_content.raw_data.dig('continue', 'plcontinue')
          break if continue_query.nil?
        end

        node.update_column(:ended_processing_links, true)
        node.update_column(:error_processing_links, false)
        node.save!

        puts "#{Time.zone.now}"
        puts "Processed links for: #{node.name}"
      rescue => error
        node.update_column(:error_processing_links, true)
        node.update_column(:ended_processing_links, false)

        puts "#{Time.zone.now}"
        puts "ERROR: Processing #{node.name}'s links: #{error}"
        puts "#{error.backtrace.join("\n")}"
      end
    end
  end
end
