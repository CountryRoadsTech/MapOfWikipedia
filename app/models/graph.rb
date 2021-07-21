class Graph < ApplicationRecord
  has_many :nodes, inverse_of: :graph, dependent: :destroy
  has_many :edges, inverse_of: :graph, dependent: :destroy
  has_many :paths, inverse_of: :graph, dependent: :destroy
  has_many :categories, inverse_of: :graph, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: true

  def self.build_from_starting_node_name(starting_node_name, graph_name)
    graph = Graph.find_by(name: graph_name) # Try to resume searching an existing graph whenever possible.
    graph = Graph.create!(name: graph_name) if graph.nil?

    Node.find_or_create_by_name(starting_node_name, graph)

    while true
      unprocessed_nodes = graph.nodes.needs_processing
      unprocessed_nodes_count = unprocessed_nodes.count

      unprocessed_nodes.each do |node|
        ProcessNodesLinksWorker.perform_async(node.id)
        node.update_column(:marked_for_processing_links, true)

        puts "#{Time.zone.now}"
        puts "Added #{node.name} to the processing queue"
      end

      break if unprocessed_nodes_count.zero?
    end

    graph
  end
end
