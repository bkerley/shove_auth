# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080820134413) do

  create_table "accounts", :force => true do |t|
    t.string   "username"
    t.string   "digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "account_id"
    t.string   "group"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nonces", :force => true do |t|
    t.string   "nonce"
    t.string   "sid"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "session_secret"
  end

  add_index "nonces", ["sid"], :name => "index_nonces_on_sid"

end
