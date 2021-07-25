class Node < ApplicationRecord
  belongs_to :graph, inverse_of: :nodes
  has_and_belongs_to_many :edges
  has_and_belongs_to_many :categories

  validates :name, :graph, presence: true
  validates :name, uniqueness: true

  def self.find_or_create_by_name(node_name)
    node = Node.find_by(name: node_name)
    if node.nil?
      node = Node.create!({name: node_name})
    end

    node
  end
end
