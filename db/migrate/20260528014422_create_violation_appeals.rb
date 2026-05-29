class CreateViolationAppeals < ActiveRecord::Migration[8.0]
  def change
    create_table :violation_appeals do |t|
      t.string :appeal_no
      t.integer :driver_id
      t.integer :order_id
      t.string :violation_type
      t.datetime :violation_time
      t.string :appeal_content
      t.jsonb :appeal_attachments
      t.string :appeal_status
      t.integer :reviewer_id
      t.string :review_opinion
      t.datetime :review_time

      t.timestamps
    end

    add_index :violation_appeals, :order_id
  end
end
