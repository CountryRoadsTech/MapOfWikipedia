require 'wikipedia'

class Node < ApplicationRecord
  belongs_to :graph, inverse_of: :nodes
  has_and_belongs_to_many :edges
  has_and_belongs_to_many :categories

  validates :name, presence: true
  validates :name, uniqueness: true

  scope :needs_processing, -> { where(began_processing_links: false).where(error_processing_links: false) }
  scope :currently_processing, -> { where(began_processing_links: true).where(ended_processing_links: false).where(error_processing_links: false) }
  scope :finished_processing, -> { where(began_processing_links: true).where(ended_processing_links: true).where(error_processing_links: false) }
  scope :error_processing, -> { where(error_processing_links: true) }

  def save_links
    return if self.began_processing_links? or self.ended_processing_links? or self.error_processing_links?

    self.update_column(:began_processing_links, true)

    begin
      continue_query = nil
      while true
        query_options = {pllimit: 500}
        query_options.merge!({plcontinue: continue_query}) if continue_query

        wikipedia_content = Wikipedia.find(name, query_options)
        unless wikipedia_content.links.nil?
          wikipedia_content.links.each do |link_name|
            linked_node = Node.find_or_create_by_name(link_name, graph)
            Edge.find_or_create_from_nodes(self, linked_node, graph)
          end
        end

        continue_query = wikipedia_content.raw_data.dig('continue', 'plcontinue')
        break if continue_query.nil?
      end

      puts "#{Time.zone.now}"
      puts "Processed links for page: #{name}"

      self.update_column(:ended_processing_links, true)
      self.update_column(:error_processing_links, false)
      self.save!
    rescue => error
      puts "#{Time.zone.now}"
      puts "Encountered an error trying to save the links for the node #{name}: #{error}"
      puts "#{error.backtrace.join("\n")}"

      self.update_column(:error_processing_links, true)
      self.update_column(:ended_processing_links, false)
    end
  end

  def self.find_or_create_by_name(node_name, graph)
    node = graph.nodes.find_by(name: node_name)
    if node.nil?
      wikipedia_content = Wikipedia.find(node_name)

      categories = []
      unless wikipedia_content.categories.nil?
        wikipedia_content.categories.each do |category_name|
          categories << Category.find_or_create_by_name(category_name)
        end
      end

      node = Node.create!(name: node_name,
                          url: wikipedia_content.fullurl,
                          summary: wikipedia_content.summary,
                          content: wikipedia_content.text,
                          raw_content: wikipedia_content.content,
                          categories: categories,
                          graph: graph)
      puts "#{Time.zone.now}"
      puts "Created new node for #{node_name}"
    end

    node
  end
end
