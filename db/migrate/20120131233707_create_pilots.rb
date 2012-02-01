class CreatePilots < ActiveRecord::Migration
  def self.up
    create_table :pilots do |t|
      t.string :name
      t.string :surname
      t.string :passport
      t.string :birthdate
      t.string :nationality
      t.integer :tshirt_size
      t.string :club_name
      t.string :address
      t.string :city
      t.string :zip_code
      t.string :country
      t.string :phone
      t.string :mobile_phone
      t.string :email
      t.integer :glider_class
      t.string :glider_manuf
      t.string :glider_model
      t.string :contact_name
      t.string :contact_relation
      t.string :contact_phone

      t.timestamps
    end
  end

  def self.down
    drop_table :pilots
  end
end
