class CreateTaskOrderRelations < ActiveRecord::Migration[8.0]
  def change
    create_table :task_order_relations do |t|
      t.integer :task_id
      t.integer :order_route_id
      t.integer :order_pickup_sort
      t.datetime :actual_pickup_time
      t.integer :order_delivery_sort
      t.datetime :actual_delivery_time
      t.string :status
      t.decimal :other_cost
      t.string :cost_remark

      t.timestamps
    end
  end
end
