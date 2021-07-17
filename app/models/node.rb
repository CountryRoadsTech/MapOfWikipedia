require 'wikipedia'

class Node < ApplicationRecord
  belongs_to :graph, inverse_of: :nodes
  has_and_belongs_to_many :edges
  has_and_belongs_to_many :categories

  validates :name, :url, presence: true
  validates :name, uniqueness: true

  def save_links
    return if self.saved_links?

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

    self.saved_links = true
    self.save!

    puts "#{Time.zone.now}"
    puts "Processed links for page: #{name}"
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
