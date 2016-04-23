require 'will_paginate/array'

class UsersController < ApplicationController
  before_action :logged_in_user , only: [:edit, :update, :index, :destroy]
  before_action :correct_user   , only: [:edit, :update, :destroy]


  def new
    @user = User.new
  end

  def index
    @users = User.find_by_sql("SELECT u.id, u.name, email, COUNT(e.id) AS count FROM users u LEFT JOIN events e ON u.id = e.user_id WHERE activated = 't'
                             GROUP BY u.name, u.id, email ORDER BY u.id").paginate(page: params[:page])
    #@users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @events = Event.where("user_id = #{@user.id}")
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
    redirect_to(root_url) unless current_user?(@user)
  end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end


end
