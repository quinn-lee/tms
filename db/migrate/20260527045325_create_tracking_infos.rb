class CreateTrackingInfos < ActiveRecord::Migration[8.0]
  def change
    create_table :tracking_infos do |t|
      t.integer :order_id
      t.string :location
      t.string :event
      t.string :description
      t.datetime :event_time
      t.integer :driver_id
      t.integer :seq
      t.jsonb :images

      t.timestamps
    end

    add_index :tracking_infos, :order_id
  end
end
