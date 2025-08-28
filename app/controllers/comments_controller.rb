class CommentsController < ApplicationController
  before_action :set_commentable

  def create
    @comment = @commentable.comments.build(comment_params)      
    unless @comment.save
      flash.now[:alert] = @comment.errors.full_messages
      render turbo_stream: turbo_stream.replace("flash", partial: "flash"),  status: :unprocessable_content
    end
  end

  private

  def set_commentable    
    if params[:doubt_id]
      @commentable = Doubt.find(params[:doubt_id])
    elsif params[:post_id]
      @commentable = Post.find(params[:post_id])    
    end
  end

  def comment_params
    params.expect(comment: [:body]).merge(user: current_user)
  end
end
