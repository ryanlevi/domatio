class RewriteSchema < ActiveRecord::Migration
  create_table "bills", :force => true do |t|
    t.string   "name"
    t.integer  "owner",      :limit => 255
    t.string   "groupid"
    t.decimal  "price",                     :precision => 6, :scale => 2
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
    t.datetime "duedate"
    t.integer  "recurring"
    t.integer  "pending"
  end

  create_table "bills_helps", :force => true do |t|
    t.integer  "bill_id"
    t.integer   "user"
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
