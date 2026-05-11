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

ActiveRecord::Schema[8.0].define(version: 2026_05_10_123054) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "branches", force: :cascade do |t|
    t.string "branch_code"
    t.string "branch_name"
    t.string "province"
    t.string "city"
    t.string "address"
    t.string "postcode"
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "contact_person"
    t.string "contact_phone"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_code"], name: "index_branches_on_branch_code", unique: true
  end

  create_table "transport_orders", force: :cascade do |t|
    t.string "order_no"
    t.integer "task_id"
    t.integer "user_id"
    t.string "goods_name"
    t.string "goods_type"
    t.boolean "is_high_value"
    t.decimal "goods_weight"
    t.decimal "goods_volume"
    t.integer "goods_quantity"
    t.string "start_address"
    t.decimal "start_latitude"
    t.decimal "start_longitude"
    t.string "shipper_name"
    t.string "shipper_phone"
    t.string "end_address"
    t.decimal "end_latitude"
    t.decimal "end_longitude"
    t.string "consignee_name"
    t.string "consignee_phone"
    t.datetime "appointment_time"
    t.boolean "need_pickup"
    t.string "order_status"
    t.decimal "order_amount"
    t.string "remark"
    t.integer "allocator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_no"], name: "index_transport_orders_on_order_no", unique: true
  end

  create_table "trucks", force: :cascade do |t|
    t.string "truck_plate"
    t.integer "branch_id"
    t.string "truck_type"
    t.string "truck_model"
    t.decimal "max_load"
    t.decimal "max_volume"
    t.string "truck_status"
    t.string "gps_device_id"
    t.string "gps_status"
    t.datetime "last_gps_time"
    t.decimal "total_mileage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "driver_ids", default: []
    t.index ["truck_plate"], name: "index_trucks_on_truck_plate", unique: true
  end

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
