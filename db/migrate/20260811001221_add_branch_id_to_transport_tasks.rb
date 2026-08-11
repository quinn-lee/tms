class AddBranchIdToTransportTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :transport_tasks, :branch_id, :integer
  end
end
