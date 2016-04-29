class EventUsersController < ApplicationController

  before_action :logged_in_user, only: [:create, :destroy]
  before_action :other_user, only: [:create, :destroy]
  before_action :attending_user, only: [:destroy]
  before_action :unattending_user, only: [:create]
  before_action :outdated, only: [:create]

  def create
    @event_sign = current_user.event_users.build(event_users_params)
    if @event_sign.save
      flash[:success] = "Signed up"
      redirect_back_or current_user
    else
      flash[:danger] = "Already signed up"
      redirect_to root_url
    end
  end

  def destroy
    EventUser.find_by(event_id: params[:id], user_id: current_user.id).destroy
    flash[:success] = "No longer signed to event"
    redirect_to current_user
  end

  private

  def event_users_params
    params.require(:event_user).permit(:user_id, :event_id)
  end

  def other_user
    @event_manager = Event.find_by(id: params[:id])
    if @event_manager.nil?
      @event_manager = Event.find_by(id: params[:event_user][:event_id])
    end
    redirect_to root_url if current_user.id == @event_manager.user_id
  end

  def attending_user
    @attendance = EventUser.find_by(user_id: current_user.id, event_id: params[:id])
    redirect_to root_url if @attendance.nil?
  end

  def unattending_user
    @attendance = EventUser.find_by(user_id: current_user.id, event_id: params[:event_id])
    redirect_to root_url unless @attendance.nil?
  end

  def outdated
    id = params[:id]
    if id.nil?
      id = params[:event_user][:event_id]
    end
    event = Event.where("id = ? AND EXTRACT(epoch FROM(date - CURRENT_TIMESTAMP)) > 0", id)
  end

end
