class ChangeZipcode < ActiveRecord::Migration
  def change
    change_column :pilots, :zipcode, :string, :limit => 40
  end
end
