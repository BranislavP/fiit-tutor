class EventsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  
  def index
    redirect_to root_url
  end

  def new
    @event = Event.new
  end

  def show
    @event = Event.find(params[:id])
    @user = User.find(@event.user_id)
  end

  def create
    Event.transaction do
      @event = current_user.events.build(event_params)
      if @event.save
        flash[:success] = "Event created"
        redirect_to root_url
      else
        render 'new'
      end
    end
  end

  def destroy
    @event.destroy
    flash[:success] = "Event deleted"
    redirect_to root_url
  end

  private

  def event_params
    params.require(:event).permit(:name, :subject, :description, :place, :cost, :date)
  end

  def correct_user
    @event = current_user.events.find_by(id: params[:id])
    redirect_to root_url if @event.nil?
  end
end
