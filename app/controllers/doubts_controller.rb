class DoubtsController < ApplicationController
  def index    
    @doubts = Doubt.with_rich_text_description_and_embeds.includes(:user, comments: :user, doubt_assignments: [:rich_text_answer, :ta]).order(created_at: :desc)    
  end

  def new
    @doubt = Doubt.new
  end

  def create
    @doubt = Doubt.new(doubt_params)
    if @doubt.save
      redirect_to doubts_path, notice: "Thanks for raising a doubt!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def doubt_params        
    params.expect(doubt: [:title, :description]).merge(user: current_user)
  end
end
