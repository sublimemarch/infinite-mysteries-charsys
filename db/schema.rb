# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160119163851) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "broad_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "campaigns", force: :cascade do |t|
    t.string   "name"
    t.integer  "build_points"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "character_has_powers", force: :cascade do |t|
    t.integer  "character_id"
    t.integer  "power_id"
    t.string   "specification"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "characters", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.integer  "broad_type_id"
    t.string   "role"
    t.integer  "approach"
    t.integer  "spirit_max"
    t.integer  "spirit_refresh"
    t.string   "regeneration_style"
    t.integer  "item"
    t.integer  "money"
    t.integer  "allies"
    t.text     "item_description"
    t.text     "money_description"
    t.text     "allies_description"
    t.integer  "stress_max"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "flaws", force: :cascade do |t|
    t.integer  "character_id"
    t.string   "flaw"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "knacks", force: :cascade do |t|
    t.integer  "character_id"
    t.string   "knack"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "powers", force: :cascade do |t|
    t.string   "name"
    t.integer  "tier"
    t.text     "description"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "requires_specification", default: false
    t.string   "specification_name",     default: ""
    t.boolean  "select_multiple",        default: false
    t.integer  "select_max",             default: 0
  end

  create_table "user_administers_campaigns", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "campaign_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "display_name"
    t.string   "email",                  default: "", null: false
    t.string   "password_digest"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
