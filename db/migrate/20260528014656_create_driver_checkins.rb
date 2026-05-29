class CreateDriverCheckins < ActiveRecord::Migration[8.0]
  def change
    create_table :driver_checkins do |t|
      t.integer :driver_id
      t.string :checkin_type
      t.datetime :checkin_time
      t.string :checkin_address
      t.decimal :checkin_lng
      t.decimal :checkin_lat
      t.jsonb :checkin_photos

      t.timestamps
    end

    add_index :driver_checkins, :driver_id
  end
end
