# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_07_23_220733) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.bigint "graph_id", null: false
    t.text "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["graph_id"], name: "index_categories_on_graph_id"
    t.index ["name"], name: "index_categories_on_name"
  end

  create_table "categories_nodes", id: false, force: :cascade do |t|
    t.bigint "node_id", null: false
    t.bigint "category_id", null: false
    t.index ["category_id", "node_id"], name: "index_categories_nodes_on_category_id_and_node_id"
    t.index ["node_id", "category_id"], name: "index_categories_nodes_on_node_id_and_category_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "edges", force: :cascade do |t|
    t.bigint "graph_id", null: false
    t.text "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["graph_id"], name: "index_edges_on_graph_id"
  end

  create_table "edges_nodes", id: false, force: :cascade do |t|
    t.bigint "node_id", null: false
    t.bigint "edge_id", null: false
    t.index ["edge_id", "node_id"], name: "index_edges_nodes_on_edge_id_and_node_id"
    t.index ["node_id", "edge_id"], name: "index_edges_nodes_on_node_id_and_edge_id"
  end

  create_table "edges_paths", id: false, force: :cascade do |t|
    t.bigint "edge_id", null: false
    t.bigint "path_id", null: false
    t.index ["edge_id", "path_id"], name: "index_edges_paths_on_edge_id_and_path_id"
    t.index ["path_id", "edge_id"], name: "index_edges_paths_on_path_id_and_edge_id"
  end

  create_table "graphs", force: :cascade do |t|
    t.text "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_graphs_on_name"
  end

  create_table "nodes", force: :cascade do |t|
    t.bigint "graph_id", null: false
    t.text "name", null: false
    t.text "url"
    t.text "summary"
    t.text "content"
    t.text "marked_up_content"
    t.boolean "marked_for_processing_links", default: false
    t.boolean "began_processing_links", default: false
    t.boolean "ended_processing_links", default: false
    t.boolean "error_processing_links", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["graph_id"], name: "index_nodes_on_graph_id"
    t.index ["name"], name: "index_nodes_on_name"
  end

  create_table "paths", force: :cascade do |t|
    t.bigint "graph_id", null: false
    t.text "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["graph_id"], name: "index_paths_on_graph_id"
  end

  add_foreign_key "categories", "graphs"
  add_foreign_key "edges", "graphs"
  add_foreign_key "nodes", "graphs"
  add_foreign_key "paths", "graphs"
end
