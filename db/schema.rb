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

ActiveRecord::Schema[8.0].define(version: 2025_04_09_192727) do
  create_table "block_headings", force: :cascade do |t|
    t.integer "level"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "block_texts", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "blocks", force: :cascade do |t|
    t.integer "page_id", null: false
    t.string "blockable_type", null: false
    t.integer "blockable_id", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blockable_type", "blockable_id"], name: "index_blocks_on_blockable"
    t.index ["page_id"], name: "index_blocks_on_page_id"
  end

  create_table "page_accesses", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "page_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_page_accesses_on_page_id"
    t.index ["user_id", "page_id"], name: "index_page_accesses_on_user_id_and_page_id", unique: true
    t.index ["user_id"], name: "index_page_accesses_on_user_id"
  end

  create_table "pages", force: :cascade do |t|
    t.string "title"
    t.integer "user_id", null: false
    t.integer "parent_page_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_public", default: true
    t.index ["parent_page_id"], name: "index_pages_on_parent_page_id"
    t.index ["user_id"], name: "index_pages_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "blocks", "pages"
  add_foreign_key "page_accesses", "pages"
  add_foreign_key "page_accesses", "users"
  add_foreign_key "pages", "pages", column: "parent_page_id"
  add_foreign_key "pages", "users"
  add_foreign_key "sessions", "users"
end
