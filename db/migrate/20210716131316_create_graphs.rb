class CreateGraphs < ActiveRecord::Migration[6.1]
  def change
    create_table :graphs do |t|
      t.text :name, null: false, unique: true, index: true

      t.timestamps
    end
  end
end
