class ChangeFsdbIdIndex < ActiveRecord::Migration
  def up
    remove_index :pilots, :fsdb_id
    add_index :pilots, [:fsdb_id, :competition_id], :unique => true
  end

  def down
    remove_index :pilots, [:fsdb_id, :competition_id]
    add_index :pilots, :fsdb_id, :unique => true
  end
end
