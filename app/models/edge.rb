class Edge < ApplicationRecord
  belongs_to :graph, inverse_of: :edges
  has_and_belongs_to_many :nodes
  has_and_belongs_to_many :paths

  validates :name, :graph, presence: true
  validates :name, uniqueness: true
  validate :nodes_must_have_exactly_two_present

  def nodes_must_have_exactly_two_present
    unless nodes.size == 2
      errors.add(:nodes, 'must have exactly two present')
    end
  end

  def self.find_or_create_from_nodes(in_node, out_node, graph)
    edge_name = "Edge between #{in_node.name} and #{out_node.name}"
    edge = graph.edges.find_by(name: edge_name)
    if edge.nil?
      edge = Edge.new(name: edge_name, graph: graph)
      edge.nodes << [in_node, out_node]
      edge.save!
    end

    edge
  end
end
