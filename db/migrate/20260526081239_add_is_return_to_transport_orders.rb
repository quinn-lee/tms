class AddIsReturnToTransportOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :transport_orders, :is_return, :boolean, default: false
    add_column :transport_orders, :parent_id, :integer
  end
end
