class AddIndexesToDoubtsAndDoubtAssignments < ActiveRecord::Migration[8.0]
  def change
    add_index :doubts, [:accepted, :status], name: 'index_doubts_on_accepted_and_status'
    add_index :doubt_assignments, [:ta_id, :status], name: 'index_doubt_assignments_on_ta_id_and_status'
  end
end
