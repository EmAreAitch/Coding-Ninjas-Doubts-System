class CreateDoubtAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :doubt_assignments do |t|
      t.references :doubt, null: false, foreign_key: true
      t.references :ta, null: false, foreign_key: { to_table: :users }
      t.integer :status, default: 0, null: false
      t.timestamps
    end
  end
end
