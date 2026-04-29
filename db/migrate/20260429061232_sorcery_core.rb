class SorceryCore < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :nickname,            null: false, index: { unique: true }
      t.string :crypted_password
      t.string :salt
      t.string :user_name
      t.string :staff_grade
      t.string :id_card
      t.string :user_phone
      t.string :driver_license
      t.string :license_type
      t.date   :license_expire_date
      t.integer :truck_id
      t.integer :whpw
      t.string :customer_code
      t.string :customer_name
      t.string :customer_type
      t.string :contact_person
      t.string :contact_phone
      t.string :contact_address
      t.string :credit_level
      t.string :status

      t.timestamps                null: false
    end
  end
end
