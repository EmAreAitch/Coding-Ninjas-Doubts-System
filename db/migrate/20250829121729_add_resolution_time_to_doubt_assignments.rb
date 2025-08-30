class AddResolutionTimeToDoubtAssignments < ActiveRecord::Migration[8.0]
  def change
    add_column :doubt_assignments, :resolution_time, :integer
  end
end
