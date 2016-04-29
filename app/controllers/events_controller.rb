class EventsController < ApplicationController
  before_action :logged_in_user, only: [:show, :create, :destroy]
  before_action :correct_user,   only: :destroy
  before_action :outdated, only: :show
  
  def index
    redirect_to root_url
  end

  def new
    @event = Event.new
  end

  def show
    @event = Event.find(params[:id])
    @user = User.find(@event.user_id)
    @event_sign = EventUser.new
    user_iden = request.remote_ip + current_user.id.to_s
    $redis.sadd("#{@event.id}", "#{user_iden}")
    @card = $redis.scard("#{@event.id}")
  end

  def create
    Event.transaction do
      @event = current_user.events.build(event_params)
      if @event.save
        $redis.del('events')
        flash[:success] = "Event created"
        redirect_to root_url
      else
        render 'new'
      end
    end
  end

  def destroy
    @event.destroy
    $redis.del('events')
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

  def outdated
    event = Event.where("id = ? AND EXTRACT (epoch FROM(date - CURRENT_TIMESTAMP)) > 0", params[:id])
    redirect_to root_url unless event.any?
  end
end
