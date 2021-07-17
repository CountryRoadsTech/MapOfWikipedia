class CreateNodes < ActiveRecord::Migration[6.1]
  def change
    create_table :nodes do |t|
      t.belongs_to :graph, foreign_key: true

      t.text :name, null: false, unique: true, index: true
      t.text :url, null: false
      t.text :summary
      t.text :content
      t.text :raw_content

      t.boolean :saved_links, default: false

      t.timestamps
    end
  end
end
