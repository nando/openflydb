class AddFsdbId < ActiveRecord::Migration
  def self.up
    remove_column :pilots, :fsdb_id
    add_column :pilots, :fsdb_id, :integer
    add_index :pilots, :fsdb_id, :unique => true
    Pilot.all.each {|p| p.update_attribute :fsdb_id, p.id}
  end

  def self.down
    remove_column :pilots, :fsdb_id
  end
end
