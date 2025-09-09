class ModeratorController < ApplicationController

  def new_assignment
    @doubts = Doubt          
          .where(accepted: false)  
          .order('doubts.created_at ASC')

    @tas = TeachingAssistant.joins(Doubt.sanitize_sql([
                "LEFT JOIN doubt_assignments da ON da.ta_id = users.id AND da.status = ?", 
                DoubtAssignment.statuses[:accepted]
              ])).where(da: {id: nil})
  end

  def create_assignment
    
  end
end
