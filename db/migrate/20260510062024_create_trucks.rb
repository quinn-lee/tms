class CreateTrucks < ActiveRecord::Migration[8.0]
  def change
    create_table :trucks do |t|
      t.string :truck_plate
      t.integer :branch_id
      t.string :truck_type
      t.string :truck_model
      t.decimal :max_load
      t.decimal :max_volume
      t.string :truck_status
      t.string :gps_device_id
      t.string :gps_status
      t.datetime :last_gps_time
      t.decimal :total_mileage

      t.timestamps
    end

    add_index :trucks, :truck_plate, unique: true
  end
end
