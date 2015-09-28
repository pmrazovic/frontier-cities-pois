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

ActiveRecord::Schema.define(version: 20150928100345) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories_pois", id: false, force: :cascade do |t|
    t.integer "poi_id"
    t.integer "category_id"
  end

  create_table "concept_category_relevances", force: :cascade do |t|
    t.integer  "concept_id"
    t.integer  "category_id"
    t.decimal  "relevance",   default: 0.0
    t.integer  "occurrences", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "concept_subcategory_relevances", force: :cascade do |t|
    t.integer  "concept_id"
    t.integer  "subcategory_id"
    t.decimal  "relevance",      default: 0.0
    t.integer  "occurrences",    default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "concepts", force: :cascade do |t|
    t.string   "name"
    t.string   "dbpedia_link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entities", force: :cascade do |t|
    t.string   "name"
    t.string   "entity_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entity_category_relevances", force: :cascade do |t|
    t.integer  "entity_id"
    t.integer  "category_id"
    t.decimal  "relevance",   default: 0.0
    t.integer  "occurrences", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entity_subcategory_relevances", force: :cascade do |t|
    t.integer  "entity_id"
    t.integer  "subcategory_id"
    t.decimal  "relevance",      default: 0.0
    t.integer  "occurrences",    default: 0
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

  create_table "filters_pois", id: false, force: :cascade do |t|
    t.integer "poi_id"
    t.integer "filter_id"
  end

  create_table "keyword_category_relevances", force: :cascade do |t|
    t.integer  "keyword_id"
    t.integer  "category_id"
    t.decimal  "relevance",   default: 0.0
    t.integer  "occurrences", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "keyword_subcategory_relevances", force: :cascade do |t|
    t.integer  "keyword_id"
    t.integer  "subcategory_id"
    t.decimal  "relevance",      default: 0.0
    t.integer  "occurrences",    default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "keywords", force: :cascade do |t|
    t.string   "text"
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

  create_table "poi_category_relevances", force: :cascade do |t|
    t.integer  "poi_id"
    t.integer  "category_id"
    t.decimal  "total_relevance"
    t.decimal  "concept_relevance"
    t.decimal  "entity_relevance"
    t.decimal  "keyword_relevance"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "normalized_relevance"
    t.decimal  "sum_relevance",        default: 0.0
  end

  create_table "poi_concepts", force: :cascade do |t|
    t.integer  "poi_id"
    t.integer  "concept_id"
    t.decimal  "relevance"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "poi_entities", force: :cascade do |t|
    t.integer "poi_id"
    t.integer "entity_id"
    t.decimal "relevance"
  end

  create_table "poi_keywords", force: :cascade do |t|
    t.integer  "poi_id"
    t.integer  "keyword_id"
    t.decimal  "relevance"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "poi_subcategory_relevances", force: :cascade do |t|
    t.integer  "poi_id"
    t.integer  "subcategory_id"
    t.decimal  "total_relevance"
    t.decimal  "concept_relevance"
    t.decimal  "entity_relevance"
    t.decimal  "keyword_relevance"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.decimal  "normalized_relevance"
    t.decimal  "sum_relevance",        default: 0.0
  end

  create_table "pois", force: :cascade do |t|
    t.string   "title"
    t.string   "subtitle"
    t.integer  "neighborhood_id"
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
    t.boolean  "top_20",            default: false
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
