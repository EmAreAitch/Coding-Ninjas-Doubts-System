class DoubtStat < ApplicationRecord
  validates :singleton_guard, inclusion: { in: [0] }  
  
  def self.instance    
    find_or_create_by!(singleton_guard: 0)
  end

  def self.select_stats
      select(
        [
          "doubts_asked",
          "doubts_resolved",
          "doubts_escalated",
          "sum_resolution_seconds / doubts_resolved as avg_resolution_seconds",
        ]
      )
  end
  
  def self.update_counters(attributes)
    where(singleton_guard: 0).update_counters(**attributes)
  end  

  def self.refresh_stats()
  status_resolved  = Doubt.statuses[:resolved]
  status_escalated = Doubt.statuses[:escalated]
  
  stats = Doubt    
  .select(
    Doubt.sanitize_sql([
      "COUNT(*) AS doubts_asked,
       SUM(CASE WHEN status = :resolved THEN 1 ELSE 0 END) AS doubts_resolved,
       SUM(CASE WHEN status = :escalated THEN 1 ELSE 0 END) AS doubts_escalated,
       SUM(CASE WHEN status = :resolved THEN resolution_time END) AS sum_resolution_seconds",
      { resolved: status_resolved, escalated: status_escalated }
    ])
  ).first.attributes.except("id")

  find_or_create_by!(singleton_guard: 0).update(**stats)
  end
end
