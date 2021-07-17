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
    number_of_consecutive_errors = 0

    while true
      begin
        unprocessed_nodes = graph.nodes.where(saved_links: false)
        unprocessed_nodes_count = unprocessed_nodes.size

        puts "#{Time.zone.now}"
        puts "Found #{unprocessed_nodes_count} unprocessed nodes, out of #{graph.nodes.size} total nodes in the graph so far"
        puts "#{number_to_percentage(unprocessed_nodes_count.to_f/TOTAL_NUMBER_OF_ENGLISH_WIKIPEDIA_PAGES.to_f, precision: 4)} complete of the map of English Wikipedia"

        unprocessed_nodes.each do |node|
          node.save_links
        end

        break if unprocessed_nodes_count.zero?
        number_of_consecutive_errors = 0
      rescue => error
        number_of_consecutive_errors += 1
        puts "#{Time.zone.now}"
        puts "Encountered an error: #{error}"
        puts "#{error.backtrace}"
        puts "#{number_of_consecutive_errors} consecutive errors so far"
        if number_of_consecutive_errors >= 10
          puts "Exiting because of too many consecutive errors (> 10)..."
          exit
        end
      end
    end

    graph
  end
end
