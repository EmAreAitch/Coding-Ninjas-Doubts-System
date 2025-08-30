class DoubtsController < ApplicationController
  include Pagy::Backend

  before_action :authorize_student, only: [:create]

  def index
    @doubts_asked = DoubtStat.instance.doubts_asked
    @pagy, @doubts = pagy_keyset(
      Doubt.with_rich_text_description_and_embeds
           .includes(
             :user,
             comments: :user,
             resolved_assignment: [{ rich_text_answer: :embeds_blobs }, :ta]
           )
           .order(created_at: :desc, id: :desc)
    )    
  end

  def show
    @doubt = Doubt.with_rich_text_description_and_embeds
                  .includes(
                    :user,
                    comments: :user,
                    resolved_assignment: [{ rich_text_answer: :embeds_blobs }, :ta]
                  )
                  .find(params.expect(:id))
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

  def authorize_student
    unless current_user.is_a?(Student)
      redirect_to doubts_path, alert: "Only students can raise doubts."
    end
  end
end
