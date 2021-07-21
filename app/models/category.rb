class Category < ApplicationRecord
  belongs_to :graph, inverse_of: :categories
  has_and_belongs_to_many :nodes

  validates :name, :graph, presence: true
  validates :name, uniqueness: true

  def self.find_or_create_by_name(category_name, graph)
    category_name.delete_prefix!('Category:')

    category = graph.categories.find_by(name: category_name)
    if category.nil?
      category = Category.create!(name: category_name, graph: graph)
    end

    category
    end
end
