class AddActualLoadTimeToTaskOrderRelations < ActiveRecord::Migration[8.0]
  def change
    add_column :task_order_relations, :order_id, :integer
    add_column :task_order_relations, :actual_loaded_time, :datetime
  end
end
