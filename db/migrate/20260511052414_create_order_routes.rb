class CreateOrderRoutes < ActiveRecord::Migration[8.0]
  def change
    create_table :order_routes do |t|
      t.integer :order_id
      t.string :first_location
      t.string :end_location
      t.integer :node_order
      t.decimal :planned_mileage
      t.integer :planned_duration
      t.datetime :expected_departure_time
      t.datetime :expected_arrival_time
      t.string :status
      t.string :remark

      t.timestamps
    end

    add_index :order_routes, :order_id
  end
end
