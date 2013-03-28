class AddExtraFieldsToPilots < ActiveRecord::Migration
  def change
    add_column :pilots, :birthdate, :date 
    add_column :pilots, :zipcode, :string, :limit => 10
    add_column :pilots, :fai_license, :string, :limit => 20
    add_column :pilots, :admin, :boolean, :default => false
    add_column :pilots, :password, :string, :limit => 128
  end
end
