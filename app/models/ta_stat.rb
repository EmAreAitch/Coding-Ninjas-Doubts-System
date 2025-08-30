class TaStat < ApplicationRecord
  belongs_to :ta, class_name: 'TeachingAssistant'
  
  validates :ta_id, uniqueness: true

  def self.select_stats
    select(
          [
            "name",
            "doubts_accepted",
            "doubts_resolved",
            "doubts_escalated",
            "sum_activity_time / doubts_resolved as avg_activity_time",
          ]
        )
  end

  def self.refresh_stats
   status_resolved  = DoubtAssignment.statuses[:resolved]
   status_escalated = DoubtAssignment.statuses[:escalated]
   
   connection.truncate(table_name)

   list = TeachingAssistant
   .joins("LEFT JOIN doubt_assignments da ON users.id = da.ta_id")
   .select(
     Doubt.sanitize_sql([
       "users.id,
        users.name as name,
        COUNT(da.id) AS doubts_accepted,
        SUM(CASE WHEN da.status = :resolved THEN 1 ELSE 0 END) AS doubts_resolved,
        SUM(CASE WHEN da.status = :escalated THEN 1 ELSE 0 END) AS doubts_escalated,
        SUM(CASE WHEN da.status = :resolved THEN da.resolution_time END) AS sum_activity_time",
       { resolved: status_resolved, escalated: status_escalated }
     ])
   ).group(:id, :name).find_in_batches do |batch|
      records = batch.map { 
        it.attributes.tap { 
          it['ta_id'] = it.delete('id') 
        } 
      }
      insert_all(records)
    end   
  end
end
