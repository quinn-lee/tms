class AddLoadingScanToTrackingInfos < ActiveRecord::Migration[8.0]
  def change
    add_column :tracking_infos, :loading_scan, :string
  end
end
