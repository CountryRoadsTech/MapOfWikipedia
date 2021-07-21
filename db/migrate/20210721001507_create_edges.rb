class CreateEdges < ActiveRecord::Migration[6.1]
  def change
    create_table :edges do |t|
      t.belongs_to :graph, null: false, foreign_key: true

      t.text :name, null: false

      t.timestamps
    end
  end
end
