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

ActiveRecord::Schema.define(:version => 20120218164622) do

  create_table "characters", :force => true do |t|
    t.integer  "state_id"
    t.string   "name",       :limit => 32
    t.date     "birthday"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "commands", :force => true do |t|
    t.string   "name",       :limit => 32
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "effects", :force => true do |t|
    t.integer  "command_id"
    t.string   "p_name",     :limit => 32
    t.integer  "e_value"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "events", :force => true do |t|
    t.integer  "state_id"
    t.string   "name",        :limit => 32,  :default => "", :null => false
    t.date     "s_date"
    t.date     "e_date"
    t.integer  "probability"
    t.string   "message",     :limit => 512
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  add_index "events", ["name"], :name => "index_events_on_name", :unique => true

  create_table "parameters", :force => true do |t|
    t.integer  "character_id"
    t.string   "name",         :limit => 32
    t.integer  "value"
    t.boolean  "is_hidden"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "results", :force => true do |t|
    t.integer  "state_id"
    t.string   "r_string"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "states", :force => true do |t|
    t.integer  "user_id"
    t.date     "c_date"
    t.date     "turn_end"
    t.integer  "c_command_id"
    t.integer  "c_event_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name",                   :limit => 32, :default => "",    :null => false
    t.string   "email",                                :default => "",    :null => false
    t.string   "encrypted_password",                   :default => "",    :null => false
    t.boolean  "is_admin",                             :default => false, :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
