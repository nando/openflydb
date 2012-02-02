class AddPaidToPilots < ActiveRecord::Migration
  def self.up
    add_column :pilots, :paid, :boolean
  end

  def self.down
    remove_column :pilots, :paid
  end
end
