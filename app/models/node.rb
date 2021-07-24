require 'wikipedia'

class Node < ApplicationRecord
  belongs_to :graph, inverse_of: :nodes
  has_and_belongs_to_many :edges
  has_and_belongs_to_many :categories

  validates :name, :graph, presence: true
  validates :name, uniqueness: true

  scope :needs_processing, -> { where(marked_for_processing_links: false).where(began_processing_links: false).where(ended_processing_links: false) }
  scope :marked_for_processing, -> { where(marked_for_processing_links: true).where(began_processing_links: false).where(ended_processing_links: false) }
  scope :currently_processing, -> { where(marked_for_processing_links: true).where(began_processing_links: true).where(ended_processing_links: false).where(error_processing_links: false) }
  scope :finished_processing, -> { where(marked_for_processing_links: true).where(began_processing_links: true).where(ended_processing_links: true).where(error_processing_links: false) }
  scope :errored_processing, -> { where(marked_for_processing_links: true).where(error_processing_links: true) }

  def self.find_or_create_by_name(node_name, graph)
    node = graph.nodes.find_by(name: node_name)
    if node.nil?
      wikipedia_content = Wikipedia.find(node_name)

      categories = []
      unless wikipedia_content.categories.nil?
        wikipedia_content.categories.each do |category_name|
          categories << Category.find_or_create_by_name(category_name, graph)
        end
      end

      node = Node.create!(name: node_name,
                          url: wikipedia_content.fullurl,
                          summary: wikipedia_content.summary,
                          content: wikipedia_content.text,
                          marked_up_content: wikipedia_content.content,
                          categories: categories,
                          graph: graph)

      unless node.marked_for_processing_links?
        node.delay.process_links
        node.update_column(:marked_for_processing_links, true)
      end

      puts "#{Time.zone.now}"
      puts "Created new node for #{node_name}"
    end

    node
  end

  def process_links
    return if began_processing_links? or ended_processing_links?
    update_column(:began_processing_links, true)
    update_column(:error_processing_links, false)

    begin
      continue_query = nil
      while true
        query_options = {pllimit: 500}
        query_options.merge!({plcontinue: continue_query}) if continue_query

        wikipedia_content = Wikipedia.find(name, query_options)
        unless wikipedia_content.links.nil?
          wikipedia_content.links.each do |link_name|
            linked_node = Node.find_or_create_by_name(link_name, graph)
            Edge.find_or_create_from_nodes(node, linked_node, graph)
          end
        end

        continue_query = wikipedia_content.raw_data.dig('continue', 'plcontinue')
        break if continue_query.nil?
      end

      update_column(:ended_processing_links, true)
      update_column(:error_processing_links, false)
      save!

      puts "#{Time.zone.now}"
      puts "Processed links for: #{name}"
    rescue => error
      update_column(:began_processing_links, false)
      update_column(:error_processing_links, true)

      puts "#{Time.zone.now}"
      puts "Error processing node #{name}'s links: #{error.backtrace.join("\n\t")}"
    end
  end
end
