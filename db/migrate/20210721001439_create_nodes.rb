class CreateNodes < ActiveRecord::Migration[6.1]
  def change
    create_table :nodes do |t|
      t.belongs_to :graph, null: false, foreign_key: true

      t.text :name, null: false, unique: true, index: true
      t.text :url
      t.text :summary
      t.text :content
      t.text :marked_up_content

      t.timestamps
    end
  end
end
