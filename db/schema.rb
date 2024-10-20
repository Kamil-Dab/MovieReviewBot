# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2024_10_20_153233) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "crawled_data", force: :cascade do |t|
    t.text "method"
    t.text "url"
    t.jsonb "headers"
    t.binary "result"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "movies", force: :cascade do |t|
    t.string "title", null: false
    t.string "release"
    t.string "genre"
    t.string "director"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "movie_id"
    t.index ["movie_id"], name: "index_movies_on_movie_id", unique: true
  end

  create_table "reviews", force: :cascade do |t|
    t.string "critic_name", null: false
    t.text "review", null: false
    t.integer "score"
    t.date "creation_date", null: false
    t.string "review_url"
    t.integer "original_score"
    t.string "score_sentiment", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "movie_id"
    t.index ["critic_name", "movie_id"], name: "index_reviews_on_critic_name_and_movie_id", unique: true
  end

  add_foreign_key "reviews", "movies"
end
