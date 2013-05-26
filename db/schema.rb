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

ActiveRecord::Schema.define(:version => 20130526001751) do

  create_table "episodes", :force => true do |t|
    t.integer  "show_id"
    t.string   "name"
    t.date     "airdate"
    t.integer  "season_number"
    t.integer  "episode_number"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "shows", :force => true do |t|
    t.integer  "api_id"
    t.string   "name"
    t.boolean  "ended"
    t.string   "airtime"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "thumbnail"
    t.string   "starring"
    t.text     "summary"
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "show_id"
    t.integer  "episode_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

end
