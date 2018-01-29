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

ActiveRecord::Schema.define(version: 20180125222237) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "batting_statistics", force: :cascade do |t|
    t.string "team_id", null: false
    t.string "player_id", null: false
    t.integer "year", null: false
    t.string "league", null: false
    t.integer "games", null: false
    t.integer "at_bats", null: false
    t.integer "runs", null: false
    t.integer "hits", null: false
    t.integer "doubles", null: false
    t.integer "triples", null: false
    t.integer "home_runs", null: false
    t.integer "runs_batted_in", null: false
    t.integer "stolen_bases", null: false
    t.integer "caught_stealing", null: false
    t.decimal "batting_average", precision: 4, scale: 3, null: false
    t.decimal "slugging_percentage", precision: 4, scale: 3, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batting_average"], name: "index_batting_statistics_on_batting_average"
    t.index ["league"], name: "index_batting_statistics_on_league"
    t.index ["player_id"], name: "index_batting_statistics_on_player_id"
    t.index ["slugging_percentage"], name: "index_batting_statistics_on_slugging_percentage"
    t.index ["team_id"], name: "index_batting_statistics_on_team_id"
    t.index ["year"], name: "index_batting_statistics_on_year"
  end

  create_table "players", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name", null: false
    t.string "player_id", null: false
    t.integer "birth_year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_players_on_player_id", unique: true
  end

  add_foreign_key "batting_statistics", "players", primary_key: "player_id", on_delete: :cascade
end
