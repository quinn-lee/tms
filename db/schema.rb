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

ActiveRecord::Schema[8.0].define(version: 2026_04_29_061233) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "users", force: :cascade do |t|
    t.string "nickname", null: false
    t.string "crypted_password"
    t.string "salt"
    t.string "user_name"
    t.string "staff_grade"
    t.string "id_card"
    t.string "user_phone"
    t.string "driver_license"
    t.string "license_type"
    t.date "license_expire_date"
    t.integer "truck_id"
    t.integer "whpw"
    t.string "customer_code"
    t.string "customer_name"
    t.string "customer_type"
    t.string "contact_person"
    t.string "contact_phone"
    t.string "contact_address"
    t.string "credit_level"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.index ["nickname"], name: "index_users_on_nickname", unique: true
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
  end
end
