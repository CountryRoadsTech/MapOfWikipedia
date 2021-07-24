class Graph < ApplicationRecord
  has_many :nodes, inverse_of: :graph, dependent: :destroy
  has_many :edges, inverse_of: :graph, dependent: :destroy
  has_many :paths, inverse_of: :graph, dependent: :destroy
  has_many :categories, inverse_of: :graph, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: true

  def self.find_or_create_by_name(graph_name)
    graph = Graph.find_by(name: graph_name)
    if graph.nil?
      graph = Graph.create!(graph_name)
    end

    graph
  end
end
