class AddCivlid < ActiveRecord::Migration
  def self.up
    add_column :pilots, :civl_id, :string
    add_column :pilots, :gender, :string, :limit => 1
    add_column :pilots, :team, :string
  end

  def self.down
    remove_column :pilots, :civl_id
    remove_column :pilots, :gender
    remove_column :pilots, :team
  end
end
