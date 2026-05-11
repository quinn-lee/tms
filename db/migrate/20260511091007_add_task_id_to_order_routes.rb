class AddTaskIdToOrderRoutes < ActiveRecord::Migration[8.0]
  def change
    add_column :order_routes, :task_id, :integer
  end
end
