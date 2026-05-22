class AddAddressDetailToTransportOrder < ActiveRecord::Migration[8.0]
  def change
    add_column :transport_orders, :shipper_city, :string
    add_column :transport_orders, :shipper_street, :string
    add_column :transport_orders, :shipper_streetnum, :string
    add_column :transport_orders, :shipper_housenum, :string
    add_column :transport_orders, :shipper_postcode, :string
    add_column :transport_orders, :consignee_city, :string
    add_column :transport_orders, :consignee_street, :string
    add_column :transport_orders, :consignee_streetnum, :string
    add_column :transport_orders, :consignee_housenum, :string
    add_column :transport_orders, :consignee_postcode, :string
    add_column :transport_orders, :branch_id, :integer
  end
end
