class CreateTaStats < ActiveRecord::Migration[8.0]
  def change
    create_table :ta_stats do |t|
      # Reference to users table
      t.references :ta, null: true, foreign_key: { to_table: :users }
      
      # Your TA-related counters
      t.bigint :doubts_accepted, default: 0
      t.bigint :doubts_resolved, default: 0
      t.bigint :doubts_escalated, default: 0
      t.bigint :sum_activity_time
      
      t.timestamps
    end
    
    # Add index for performance
    add_index :ta_stats, [:id, :ta_id], unique: true
  end
end
