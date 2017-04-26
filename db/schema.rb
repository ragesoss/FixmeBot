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

ActiveRecord::Schema.define(version: 20170426025646) do

  create_table "articles", force: :cascade do |t|
    t.string   "title"
    t.integer  "latest_revision"
    t.datetime "latest_revision_datetime"
    t.string   "rating"
    t.float    "wp10"
    t.float    "average_views"
    t.date     "average_views_updated_at"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.boolean  "tweeted"
    t.boolean  "redirect"
    t.string   "twitter_status_id"
  end

  create_table "reactions", force: :cascade do |t|
    t.string   "twitter_status_id"
    t.string   "original_status"
    t.integer  "article_id"
    t.datetime "responded_at"
  end

  add_index "reactions", ["twitter_status_id"], name: "index_reactions_on_twitter_status_id", unique: true

end
