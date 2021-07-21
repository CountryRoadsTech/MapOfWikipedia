class Graph < ApplicationRecord
  has_many :nodes, inverse_of: :graph, dependent: :destroy
  has_many :edges, inverse_of: :graph, dependent: :destroy
  has_many :paths, inverse_of: :graph, dependent: :destroy
  has_many :categories, through: :nodes

  validates :name, presence: true
  validates :name, uniqueness: true
end
