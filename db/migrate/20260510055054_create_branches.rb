class CreateBranches < ActiveRecord::Migration[8.0]
  def change
    create_table :branches do |t|
      t.string :branch_code
      t.string :branch_name
      t.string :province
      t.string :city
      t.string :address
      t.string :postcode
      t.decimal :latitude
      t.decimal :longitude
      t.string :contact_person
      t.string :contact_phone
      t.string :status

      t.timestamps
    end

    add_index :branches, :branch_code, unique: true
  end
end
