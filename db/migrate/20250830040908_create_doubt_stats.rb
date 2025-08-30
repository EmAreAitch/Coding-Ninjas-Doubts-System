class CreateDoubtStats < ActiveRecord::Migration[8.0]
  def change
    create_table :doubt_stats do |t|
      # Your doubt-related counters
      t.bigint :doubts_asked, default: 0
      t.bigint :doubts_resolved, default: 0
      t.bigint :doubts_escalated, default: 0
      t.bigint :sum_resolution_seconds
      
      # Guard column for singleton
      t.integer :singleton_guard, default: 0, null: false
      
      t.timestamps
    end
    
    add_index :doubt_stats, :singleton_guard, unique: true
    
    # Create the single record
    DoubtStat.find_or_create_by!(singleton_guard: 0)
  end
end
