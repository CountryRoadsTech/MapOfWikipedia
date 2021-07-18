include ActionView::Helpers

class Graph < ApplicationRecord
  has_many :nodes, inverse_of: :graph, dependent: :destroy
  has_many :edges, inverse_of: :graph, dependent: :destroy
  has_many :paths, inverse_of: :graph, dependent: :destroy
  has_many :categories, through: :nodes

  validates :name, presence: true
  validates :name, uniqueness: true

  TOTAL_NUMBER_OF_ENGLISH_WIKIPEDIA_PAGES = 6338381

  def self.build_from_starting_node_name(starting_node_name, graph_name)
    graph = Graph.find_by(name: graph_name)
    graph = Graph.create!(name: graph_name) if graph.nil?

    Node.find_or_create_by_name(starting_node_name, graph)

    while true
        unprocessed_nodes = graph.nodes.needs_processing
        unprocessed_nodes_count = unprocessed_nodes.size
        errored_nodes_count = graph.nodes.error_processing.size
        processed_nodes_count = graph.nodes.finished_processing.size
        total_nodes_count = graph.nodes.size
        total_edges_count = graph.edges.size

        puts "#{Time.zone.now}"
        puts "Found #{unprocessed_nodes_count} unprocessed nodes, out of #{total_nodes_count} total nodes in the graph so far"
        puts "#{errored_nodes_count} nodes errored trying to save links so far"
        puts "#{total_edges_count} edges in the graph so far"
        puts "#{number_to_percentage(processed_nodes_count.to_f/TOTAL_NUMBER_OF_ENGLISH_WIKIPEDIA_PAGES.to_f, precision: 4)} complete"

        unprocessed_nodes.each do |node|
          SaveLinksJob.perform_later(node)
        end

        break if unprocessed_nodes_count.zero?
    end

    graph
  end
end
