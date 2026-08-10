class AddTrackingNumToTransportOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :transport_orders, :tracking_num, :string
  end
end
