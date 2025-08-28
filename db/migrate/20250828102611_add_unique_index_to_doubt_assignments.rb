class AddUniqueIndexToDoubtAssignments < ActiveRecord::Migration[8.0]
  def change
    add_index :doubt_assignments, [:ta_id, :doubt_id], unique: true
  end
end
