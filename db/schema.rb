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

ActiveRecord::Schema.define(version: 20150914175147) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "filters", force: :cascade do |t|
    t.string   "name"
    t.integer  "category_id"
    t.integer  "subcategory_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "neighborhoods", force: :cascade do |t|
    t.string   "name"
    t.integer  "district_id"
    t.string   "district_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pois", force: :cascade do |t|
    t.string   "title"
    t.string   "subtitle"
    t.integer  "neighbourhood_id"
    t.string   "address"
    t.string   "telephone_number"
    t.string   "website_url"
    t.string   "longitude"
    t.string   "latitude"
    t.string   "transport"
    t.string   "working_hours"
    t.string   "prices"
    t.text     "description"
    t.string   "restaurant_prices"
    t.string   "hotel_categories"
    t.string   "festival_date"
    t.text     "data"
    t.string   "michelin_stars"
    t.string   "architect_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pois_categories", id: false, force: :cascade do |t|
    t.integer "poi_id"
    t.integer "category_id"
  end

  create_table "pois_filters", id: false, force: :cascade do |t|
    t.integer "poi_id"
    t.integer "filter_id"
  end

  create_table "pois_subcategories", id: false, force: :cascade do |t|
    t.integer "poi_id"
    t.integer "subcategory_id"
  end

  create_table "subcategories", force: :cascade do |t|
    t.string   "name"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
