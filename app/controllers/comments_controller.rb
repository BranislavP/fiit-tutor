class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    comment = current_user.comments.build(comment_params)
    if comment.save
      flash[:success] = "Comment created"
    else
      flash[:danger] = "Could not send comment"
    end
    redirect_to event_path params[:comment][:event_id]
  end

  def destroy
    Comment.find(params[:id]).destroy
    redirect_to event_path params[:event_id]
  end

  private

  def comment_params
    params.require(:comment).permit(:user_id, :event_id, :content)
  end
end
