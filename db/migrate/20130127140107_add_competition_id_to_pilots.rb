class AddCompetitionIdToPilots < ActiveRecord::Migration
  def change
    add_column :pilots, :competition_id, :integer
    Pilot.update_all(:competition_id => 1)
  end
end
