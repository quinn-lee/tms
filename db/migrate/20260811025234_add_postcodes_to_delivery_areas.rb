class AddPostcodesToDeliveryAreas < ActiveRecord::Migration[8.0]
  def change
    add_column :delivery_areas, :postcodes, :string
  end
end
