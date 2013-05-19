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

ActiveRecord::Schema.define(:version => 20130519120000) do

  create_table "competitions", :force => true do |t|
    t.string "name"
    t.string "dates"
    t.string "url"
    t.string "logo_url"
  end

  create_table "pilots", :force => true do |t|
    t.string   "name"
    t.string   "surname"
    t.string   "blood_type"
    t.string   "allergies"
    t.string   "nationality"
    t.integer  "tshirt_size"
    t.string   "club_name"
    t.string   "address"
    t.string   "city"
    t.string   "license"
    t.string   "country"
    t.string   "phone"
    t.string   "passport"
    t.string   "email"
    t.integer  "glider_class"
    t.string   "glider_manuf"
    t.string   "glider_model"
    t.string   "contact_name"
    t.string   "contact_relation"
    t.string   "contact_phone"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.boolean  "paid"
    t.string   "civl_id"
    t.string   "gender",             :limit => 1
    t.string   "team"
    t.integer  "fsdb_id"
    t.integer  "competition_id"
    t.date     "birthdate"
    t.string   "zipcode",            :limit => 40
    t.string   "fai_license",        :limit => 20
    t.boolean  "admin",                             :default => false
    t.string   "password",           :limit => 128
    t.string   "livetrack_username", :limit => 40
    t.string   "tracker_username",   :limit => 40
  end

  add_index "pilots", ["fsdb_id", "competition_id"], :name => "index_pilots_on_fsdb_id_and_competition_id", :unique => true

end
