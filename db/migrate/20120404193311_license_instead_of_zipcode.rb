class LicenseInsteadOfZipcode < ActiveRecord::Migration
  def self.up
    rename_column :pilots, :zip_code, :license
    rename_column :pilots, :mobile_phone, :passport
  end

  def self.down
    rename_column :pilots, :license, :zip_code
    rename_column :pilots, :passport, :mobile_phone
  end
end
