class MoveFsdbIds < ActiveRecord::Migration
  def self.up
    Pilot.all(:conditions => ['fsdb_id > ?', 20]).each {|p|
      p.update_attribute :fsdb_id, p.fsdb_id + 100
    }
  end

  def self.down
  end
end
