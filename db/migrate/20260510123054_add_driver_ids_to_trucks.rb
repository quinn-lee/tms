class AddDriverIdsToTrucks < ActiveRecord::Migration[8.0]
  def change
    add_column :trucks, :driver_ids,   :jsonb, default: []
  end
end
