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
    @comments = Comment.find_by_sql("SELECT u.id AS iden, c.id, name, content, c.event_id FROM comments c JOIN users u ON u.id = c.user_id
                                   WHERE c.event_id = #{params[:id]} ORDER BY c.created_at ASC").paginate(page: params[:page], per_page: 10)
    user_iden = request.remote_ip + current_user.id.to_s
    $redis.pfadd("#{@event.id}", "#{user_iden}")
    @card = $redis.pfcount("#{@event.id}")
    @new_comment = Comment.new
  end

  def create
    Event.transaction do
      @event = current_user.events.build(event_params)
      if @event.save
        $redis.del('events')
        flash[:success] = "Event created"
        redirect_to @event
      else
        render 'new'
      end
    end
  end

  def destroy
    @event.destroy
    $redis.del('events')
    $redis.del(@event.id)
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
    id = params[:id]
    if id.nil?
      id = params[:event_user][:event_id]
    end
    event = Event.where("id = ? AND EXTRACT(epoch FROM(date + interval '1 day' - CURRENT_TIMESTAMP)) > 0", id)
    redirect_to root_url unless event.any?
  end

end
