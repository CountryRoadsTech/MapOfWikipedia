class CreateNodes < ActiveRecord::Migration[6.1]
  def change
    create_table :nodes do |t|
      t.belongs_to :graph, null: false, foreign_key: true

      t.text :name, null: false, unique: true, index: true
      t.text :url
      t.text :summary
      t.text :content
      t.text :marked_up_content

      t.boolean :marked_for_processing_links, default: false
      t.boolean :began_processing_links, default: false
      t.boolean :ended_processing_links, default: false
      t.boolean :error_processing_links, default: false

      t.timestamps
    end
  end
end
