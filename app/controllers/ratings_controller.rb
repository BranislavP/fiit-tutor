class RatingsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  def create
    rating = current_user.ratings.build(rating_params)
    if rating.save
      flash[:success] = "Rating created"
      $redis.del('events')
    else
      flash[:danger] = "Could not rate"
    end
    redirect_to user_path params[:rating][:tutor_id]
  end

  def destroy
    Rating.find(params[:id]).destroy
    $redis.del('events')
    redirect_to user_path params[:user_id]
  end

  private

  def rating_params
    params.require(:rating).permit(:tutor_id, :score, :content)
  end



end
