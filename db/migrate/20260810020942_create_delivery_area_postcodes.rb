class CreateDeliveryAreaPostcodes < ActiveRecord::Migration[8.0]
  def change
    create_table :delivery_area_postcodes do |t|
      t.integer :area_id
      t.string :post_code
      t.string :city
      t.string :district
      t.boolean :is_exclude
      t.string :zone_restriction

      t.timestamps
    end
  end
end
