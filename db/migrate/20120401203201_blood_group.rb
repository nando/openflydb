class CreatePilots < ActiveRecord::Migration
  def self.up
    rename_column :pilots, :passport, :blood_type
    rename_column :pilots, :birthdate, :allergies
  end

  def self.down
    rename_column :pilots, :blood_type, :passport
    rename_column :pilots, :allergies, :birthdate
  end
end
