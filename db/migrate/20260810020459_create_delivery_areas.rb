class CreateDeliveryAreas < ActiveRecord::Migration[8.0]
  def change
    create_table :delivery_areas do |t|
      t.string :area_code
      t.string :area_name
      t.string :dispatch_frequency
      t.integer :min_order_num
      t.decimal :truck_max_volume
      t.decimal :truck_max_weight_t
      t.boolean :enable_merge
      t.string :status

      t.timestamps
    end
  end
end
