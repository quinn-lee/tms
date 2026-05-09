class CreateTransportOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :transport_orders do |t|
      t.string :order_no
      t.integer :task_id
      t.integer :user_id
      t.string :goods_name
      t.string :goods_type
      t.boolean :is_high_value
      t.decimal :goods_weight
      t.decimal :goods_volume
      t.integer :goods_quantity
      t.string :start_address
      t.decimal :start_latitude
      t.decimal :start_longitude
      t.string :shipper_name
      t.string :shipper_phone
      t.string :end_address
      t.decimal :end_latitude
      t.decimal :end_longitude
      t.string :consignee_name
      t.string :consignee_phone
      t.datetime :appointment_time
      t.boolean :need_pickup
      t.string :order_status
      t.decimal :order_amount
      t.string :remark
      t.integer :allocator_id

      t.timestamps
    end

    add_index :transport_orders, :order_no, unique: true
  end
end
