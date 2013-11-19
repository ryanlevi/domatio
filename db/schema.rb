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
# It's strongly recommended to check this file into your version control system.


ActiveRecord::Schema.define(:version => 20131030010741) do


  create_table "bills", :force => true do |t|
    t.string   "name"
    t.string   "owner"
    t.string   "groupid"
    t.decimal  "price",      :precision => 6, :scale => 2
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.datetime "duedate"
    t.integer  "recurring"
  end

  create_table "bills_helps", :force => true do |t|
    t.integer  "bill_id"
    t.string   "user"
    t.decimal  "amount"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "pending"

  end

  create_table "chores", :force => true do |t|
    t.string   "name"
    t.string   "groupid"
    t.datetime "time"
    t.integer  "recurrence"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "chores_helps", :force => true do |t|
    t.integer  "chore_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "pending"
  end

  create_table "discussion_messages", :force => true do |t|
    t.integer  "user_id"
    t.text     "content"
    t.integer  "discussion_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "discussions", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "title"
    t.integer  "messages_count"
  end

  create_table "groups", :force => true do |t|
    t.string   "groupname"
    t.string   "groupid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "groupid"
    t.string   "name"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
  end

end
