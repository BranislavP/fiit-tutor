require 'will_paginate/array'

class UsersController < ApplicationController
  before_action :logged_in_user , only: [:edit, :update, :index, :destroy]
  before_action :correct_user   , only: [:edit, :update, :destroy]


  def new
    @user = User.new
  end

  def index
    @q = User.ransack(params[:q])
    if params[:q]
      @users = @q.result(distinct: true).where("activated = 't'").order("id ASC").paginate(page: params[:page])
    else
      @users = User.where("activated = 't'").order("id ASC").paginate(page: params[:page])
    end
  end

  def show
    @user = User.find(params[:id])
    @events = Event.where("user_id = ? AND EXTRACT(epoch FROM(date + interval '1 day' - CURRENT_TIMESTAMP)) > 0", @user.id)
    @signed_events = Event.find_by_sql(["SELECT e.id, e.name FROM event_users euv JOIN users u ON u.id = euv.user_id
                                       JOIN events e ON e.id = euv.event_id WHERE euv.user_id = ?
                                       AND EXTRACT(epoch FROM(e.date + interval '1 day' - CURRENT_TIMESTAMP)) > 0", @user.id])
    @new_rating = Rating.new
    @rating = Rating.find_by_sql(["SELECT u.name, user_id, score, content, tutor_id, r.id FROM ratings r JOIN users u ON u.id = r.user_id
                                 WHERE tutor_id = ? AND user_id = ?
                                ORDER BY r.created_at ASC", params[:id], current_user.id]).paginate(page: params[:rate], per_page: 5)
    @average = User.find_by_sql(["SELECT coalesce(AVG(score), -1) AS average FROM users u LEFT JOIN ratings r ON u.id = r.tutor_id
                                WHERE u.id = ? GROUP BY u.id", @user.id])
    redirect_to root_url and return unless @user.activated?
  end

  def destroy
    User.find(params[:id]).destroy
    $redis.del('events')
    flash[:success] = "User deleted"
    redirect_to root_url
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

    private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # Before filters

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless (current_user?(@user) || current_user.admin?)
  end

end
