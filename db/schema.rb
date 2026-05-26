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

ActiveRecord::Schema[8.0].define(version: 2026_05_26_025412) do
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

  create_table "order_routes", force: :cascade do |t|
    t.integer "order_id"
    t.string "first_location"
    t.string "end_location"
    t.integer "node_order"
    t.decimal "planned_mileage"
    t.integer "planned_duration"
    t.datetime "expected_departure_time"
    t.datetime "expected_arrival_time"
    t.string "status"
    t.string "remark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "first_detail"
    t.jsonb "last_detail"
    t.index ["order_id"], name: "index_order_routes_on_order_id"
  end

  create_table "task_order_relations", force: :cascade do |t|
    t.integer "task_id"
    t.integer "order_route_id"
    t.integer "order_pickup_sort"
    t.datetime "actual_pickup_time"
    t.integer "order_delivery_sort"
    t.datetime "actual_delivery_time"
    t.string "status"
    t.decimal "other_cost"
    t.string "cost_remark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.string "shipper_city"
    t.string "shipper_street"
    t.string "shipper_streetnum"
    t.string "shipper_housenum"
    t.string "shipper_postcode"
    t.string "consignee_city"
    t.string "consignee_street"
    t.string "consignee_streetnum"
    t.string "consignee_housenum"
    t.string "consignee_postcode"
    t.integer "branch_id"
    t.datetime "arrival_time"
    t.index ["order_no"], name: "index_transport_orders_on_order_no", unique: true
  end

  create_table "transport_tasks", force: :cascade do |t|
    t.string "task_no"
    t.integer "sequence_no"
    t.integer "order_quantity"
    t.jsonb "driver_ids"
    t.date "task_date"
    t.jsonb "route_plan"
    t.integer "start_branch_id"
    t.integer "end_branch_id"
    t.integer "truck_id"
    t.string "truck_delivery_status"
    t.datetime "truck_delivery_time"
    t.datetime "truck_recovery_time"
    t.datetime "expected_departure_time"
    t.datetime "expected_arrival_time"
    t.datetime "actual_departure_time"
    t.datetime "actual_arrival_time"
    t.decimal "loading_weight"
    t.decimal "loading_volumn"
    t.decimal "transport_mileage"
    t.integer "transport_duration"
    t.decimal "transport_fee"
    t.decimal "oil_cost"
    t.decimal "toll_fee"
    t.decimal "other_cost"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_ids"], name: "index_transport_tasks_on_driver_ids"
    t.index ["task_no"], name: "index_transport_tasks_on_task_no"
    t.index ["truck_id"], name: "index_transport_tasks_on_truck_id"
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
