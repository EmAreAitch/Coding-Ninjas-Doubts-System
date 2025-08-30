class DashboardController < ApplicationController  
  before_action :ensure_teacher!

  def show
    @dashboard_stats = calculate_dashboard_stats
    @dashboard_stats["avg_resolution_seconds"] = transform_average_seconds(@dashboard_stats["avg_resolution_seconds"])
    @ta_reports = calculate_ta_reports
    @ta_reports.each { 
      it["avg_activity_time"] = transform_average_seconds(it["avg_activity_time"]) if it["avg_activity_time"].present? 
    }
  end

  private

  def ensure_teacher!
    redirect_to root_path, alert: "Please sign in as Teaching Assistant" unless current_user.is_a? TeachingAssistant
  end

  def calculate_dashboard_stats    
    status_resolved  = Doubt.statuses[:resolved]
    status_escalated = Doubt.statuses[:escalated]
    
    Doubt    
    .select(
      Doubt.sanitize_sql([
        "COUNT(*) AS doubts_asked,
         SUM(CASE WHEN status = :resolved THEN 1 ELSE 0 END) AS doubts_resolved,
         SUM(CASE WHEN status = :escalated THEN 1 ELSE 0 END) AS doubts_escalated,
         AVG(CASE WHEN status = :resolved THEN resolution_time END) AS avg_resolution_seconds",
        { resolved: status_resolved, escalated: status_escalated }
      ])
    ).first
  end

  def calculate_ta_reports
    status_resolved  = DoubtAssignment.statuses[:resolved]
    status_escalated = DoubtAssignment.statuses[:escalated]
    
    TeachingAssistant
    .joins("LEFT JOIN doubt_assignments da ON users.id = da.ta_id")
    .select(
      Doubt.sanitize_sql([
        "users.name,
         COUNT(da.id) AS doubts_accepted,
         SUM(CASE WHEN da.status = :resolved THEN 1 ELSE 0 END) AS doubts_resolved,
         SUM(CASE WHEN da.status = :escalated THEN 1 ELSE 0 END) AS doubts_escalated,
         AVG(CASE WHEN da.status = :resolved THEN da.resolution_time END) AS avg_activity_time",
        { resolved: status_resolved, escalated: status_escalated }
      ])
    ).group(:id, :name)
  end

  def transform_average_seconds(seconds)    
    highest_order = ActiveSupport::Duration.build(seconds).parts.first
    highest_order[1] = (seconds.fdiv ActiveSupport::Duration::PARTS_IN_SECONDS[highest_order[0]]).round
    highest_order.reverse.join(" ").singularize.pluralize(highest_order[1])
  end
end
