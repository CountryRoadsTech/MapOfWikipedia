class CreateJoinTableNodesCategories < ActiveRecord::Migration[6.1]
  def change
    create_join_table :nodes, :categories do |t|
      t.index [:node_id, :category_id]
      t.index [:category_id, :node_id]
    end
  end
end
