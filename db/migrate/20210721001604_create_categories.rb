class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|
      t.belongs_to :graph, null: false, foreign_key: true

      t.text :name, null: false, unique: true, index: true

      t.timestamps
    end
  end
end
