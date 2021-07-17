class CreateJoinTableNodesEdges < ActiveRecord::Migration[6.1]
  def change
    create_join_table :nodes, :edges do |t|
      # t.index [:node_id, :edge_id]
      # t.index [:edge_id, :node_id]
    end
  end
end
