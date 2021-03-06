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

ActiveRecord::Schema.define(:version => 20121214191314) do

  create_table "calendars", :force => true do |t|
    t.string   "kind"
    t.string   "etag"
    t.string   "google_id"
    t.string   "summary"
    t.string   "description"
    t.string   "time_zone"
    t.integer  "color_id"
    t.string   "background_color"
    t.string   "foreground_color"
    t.boolean  "selected"
    t.string   "access_role"
    t.boolean  "active",           :default => true
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "user_id"
  end

  create_table "events", :force => true do |t|
    t.string   "google_id"
    t.string   "g_created"
    t.string   "g_updated"
    t.string   "summary"
    t.string   "location"
    t.datetime "start"
    t.datetime "end"
    t.string   "timezone"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.text     "description"
    t.integer  "calendar_id"
    t.string   "recurringEventId"
    t.boolean  "skip",             :default => true
  end

  create_table "places", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
  end

  add_index "places", ["user_id"], :name => "user_id_ix"

  create_table "users", :force => true do |t|
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "email"
    t.string   "token"
    t.time     "token_expires_at"
    t.string   "refresh_token"
    t.string   "timezone"
    t.string   "travel_mode"
  end

end
