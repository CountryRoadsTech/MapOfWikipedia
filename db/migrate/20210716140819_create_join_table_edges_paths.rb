class CreateJoinTableEdgesPaths < ActiveRecord::Migration[6.1]
  def change
    create_join_table :edges, :paths do |t|
      # t.index [:edge_id, :path_id]
      # t.index [:path_id, :edge_id]
    end
  end
end
