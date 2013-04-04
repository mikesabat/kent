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

ActiveRecord::Schema.define(:version => 20130403233309) do

  create_table "quotes", :force => true do |t|
    t.integer  "stock_id"
    t.decimal  "neg1_open"
    t.decimal  "neg1_close"
    t.decimal  "zero_open"
    t.decimal  "zero_close"
    t.date     "date"
    t.string   "time"
    t.decimal  "eps_estimate"
    t.decimal  "eps_actual"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.text     "date_text"
    t.text     "period"
  end

end
