class AddTaskOrderToOrderRoutes < ActiveRecord::Migration[8.0]
  def change
    add_column :order_routes, :task_order, :integer
  end
end
