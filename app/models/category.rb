class Category < ApplicationRecord
  has_and_belongs_to_many :nodes

  validates :name, presence: true
  validates :name, uniqueness: true

  def self.find_or_create_by_name(category_name)
    category_name.delete_prefix!('Category:')

    category = Category.find_by(name: category_name)
    if category.nil?
      category = Category.create!(name: category_name)
    end

    category
  end
end
