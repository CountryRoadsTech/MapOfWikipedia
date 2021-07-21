class Path < ApplicationRecord
  belongs_to :graph, inverse_of: :paths
  has_and_belongs_to_many :edges
  has_many :nodes, through: :edges

  validates :name, :graph, presence: true
end
