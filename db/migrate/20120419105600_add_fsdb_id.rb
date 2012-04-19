class AddFsdbId < ActiveRecord::Migration
  def self.up
    add_column :pilots, :fsdb_id, :string
    add_index :fsdb_id, :unique => true
    Pilot.all.each {|p| p.update_attribute :fsdb_id, p.id}
  end

  def self.down
    remove_column :pilots, :fsdb_id
  end
end
