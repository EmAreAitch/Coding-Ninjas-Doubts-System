module DashboardHelper
  def format_duration(seconds)    
    highest_order = ActiveSupport::Duration.build(seconds).parts.first
    highest_order[1] = (seconds.fdiv ActiveSupport::Duration::PARTS_IN_SECONDS[highest_order[0]]).round
    highest_order.reverse.join(" ").singularize.pluralize(highest_order[1])
  end
end
