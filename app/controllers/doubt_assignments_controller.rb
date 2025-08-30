class DoubtAssignmentsController < ApplicationController
  before_action :authorize_ta!  
  before_action :solve_accepted_doubt, except: [:show, :update]
  
  def index    
    @doubts = Doubt
      .joins(Doubt.sanitize_sql([
        "LEFT JOIN doubt_assignments da ON doubts.id = da.doubt_id AND da.ta_id = ?", 
        current_user.id
      ]))
      .where(accepted: false, da: {id: nil})  
      .order('doubts.created_at ASC')
  end

  def show
    @doubt_assignment = DoubtAssignment.find_by(id: params.expect(:id), ta: current_user, status: :accepted)
    @doubt = Doubt.with_rich_text_description_and_embeds.includes(:user, comments: :user).find_by(id: @doubt_assignment.doubt_id)
  end

  def create    
    @assignment = DoubtAssignment.new(assignment_params)    
    if @assignment.save
      redirect_to @assignment, notice: "Success! Now you can solve this doubt"
    else
      flash.now[:alert] = @assignment.errors.full_messages
      render turbo_stream: turbo_stream.replace("flash", partial: "flash")
    end
  end

  def update
    @assignment = DoubtAssignment.find_by(id: params.expect(:id), ta: current_user, status: :accepted)
    if @assignment.update(update_params)
      redirect_to doubt_assignments_path, notice: @assignment.resolved? ? "Answer submitted!" : "Escalated!"
    else
      flash.now[:alert] = @assignment.errors.full_messages
      render turbo_stream: turbo_stream.replace("flash", partial: "flash")
    end
  end

  private

  def solve_accepted_doubt
    assignment = DoubtAssignment.find_by(ta: current_user, status: :accepted)
    if assignment
      redirect_to assignment, notice: "You have an accepted doubt to solve!" 
    end
  end

  def authorize_ta!
    unless current_user.is_a? TeachingAssistant
      redirect_to root_path, alert: "You need to sign in as TA"
    end
  end

  def assignment_params
    params.expect(doubt_assignment: [:doubt_id]).merge(ta: current_user)
  end

  def update_params
    params.expect(doubt_assignment: [:answer, :status])
  end
end
