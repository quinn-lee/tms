class CreateLoadingScanRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :loading_scan_records do |t|
      t.integer :order_id
      t.integer :driver_id
      t.datetime :scan_time
      t.string :remark
      t.string :scan_type

      t.timestamps
    end

    add_index :loading_scan_records, :order_id
  end
end
