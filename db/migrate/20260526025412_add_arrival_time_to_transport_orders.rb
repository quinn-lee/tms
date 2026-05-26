class AddArrivalTimeToTransportOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :transport_orders, :arrival_time, :datetime
  end
end
