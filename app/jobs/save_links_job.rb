require 'wikipedia'

class SaveLinksJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 3

  def perform(node)
    if node.nil?
      puts "#{Time.zone.now}"
      puts "Found a nil node in save links job!"
    else
      return if node.began_processing_links? or node.ended_processing_links? or node.error_processing_links?
      node.update_column(:began_processing_links, true)

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

        puts "#{Time.zone.now}"
        puts "Processed links for page: #{node.name}"

        node.update_column(:ended_processing_links, true)
        node.update_column(:error_processing_links, false)
        node.save!
      rescue => error
        puts "#{Time.zone.now}"
        puts "Encountered an error trying to save the links for the node #{node.name}: #{error}"
        puts "#{error.backtrace.join("\n")}"

        node.update_column(:error_processing_links, true)
        node.update_column(:ended_processing_links, false)
      end
    end
  end
end
