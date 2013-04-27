class AddLivetrackUsernames < ActiveRecord::Migration
  def change
    add_column :pilots, :livetrack_username, :string, :limit => 40
    add_column :pilots, :tracker_username, :string, :limit => 40
  end

end
