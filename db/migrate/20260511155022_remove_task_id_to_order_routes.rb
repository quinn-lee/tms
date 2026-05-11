class RemoveTaskIdToOrderRoutes < ActiveRecord::Migration[8.0]
  def change
    remove_column :order_routes, :task_id
  end
end
