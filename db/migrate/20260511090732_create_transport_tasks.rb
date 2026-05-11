class CreateTransportTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :transport_tasks do |t|
      t.string :task_no
      t.integer :sequence_no
      t.integer :order_quantity
      t.jsonb :driver_ids, default: []
      t.date :task_date
      t.jsonb :route_plan
      t.integer :start_branch_id
      t.integer :end_branch_id
      t.integer :truck_id
      t.string :truck_delivery_status
      t.datetime :truck_delivery_time
      t.datetime :truck_recovery_time
      t.datetime :expected_departure_time
      t.datetime :expected_arrival_time
      t.datetime :actual_departure_time
      t.datetime :actual_arrival_time
      t.decimal :loading_weight
      t.decimal :loading_volumn
      t.decimal :transport_mileage
      t.integer :transport_duration
      t.decimal :transport_fee
      t.decimal :oil_cost
      t.decimal :toll_fee
      t.decimal :other_cost
      t.string :status

      t.timestamps
    end

    add_index :transport_tasks, :task_no
    add_index :transport_tasks, :truck_id
    add_index :transport_tasks, :driver_ids
  end
end
