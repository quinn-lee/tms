class AddDetailToOrderRoutes < ActiveRecord::Migration[8.0]
  def change
    add_column :order_routes, :first_detail, :jsonb
    add_column :order_routes, :last_detail, :jsonb
  end
end
