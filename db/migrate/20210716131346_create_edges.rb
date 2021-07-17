class CreateEdges < ActiveRecord::Migration[6.1]
  def change
    create_table :edges do |t|
      t.belongs_to :graph, foreign_key: true

      t.text :name, null: false

      t.timestamps
    end
  end
end
