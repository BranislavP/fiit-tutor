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
    @event = Event.find_by_sql(["SELECT e.id, e.description, e.place, e.date, e.cost, e.user_id, e.name, s.acronym, s.name AS sub_name FROM events e
                               JOIN subjects s ON s.id = e.subject_id WHERE e.id = ? LIMIT 1", params[:id]])
    @user = User.find(@event[0].user_id)
    @event_sign = EventUser.new
    @comments = Comment.find_by_sql(["SELECT u.id AS iden, c.id, name, content, c.event_id FROM comments c JOIN users u ON u.id = c.user_id
                                   WHERE c.event_id = ? ORDER BY c.created_at ASC", params[:id]]).paginate(page: params[:page], per_page: 10)
    user_iden = request.remote_ip + current_user.id.to_s
    $redis.pfadd("#{@event[0].id}", "#{user_iden}")
    @card = $redis.pfcount("#{@event[0].id}")
    @new_comment = Comment.new
    @users = User.find_by_sql(["SELECT u.name FROM users u JOIN event_users eu ON u.id = eu.user_id WHERE eu.event_id = ?", @event[0].id])
    @count = @users.count
    @rating = User.find_by_sql(["SELECT coalesce(round((AVG(score))::numeric,1), -1) AS score FROM users u LEFT JOIN ratings r ON r.tutor_id = u.id WHERE u.id = ?", @user.id])
  end

  def create
    Event.transaction do
      @event = current_user.events.build(event_params)
      if @event.save
        $redis.del('events')
        subject = Subject.find(@event.subject_id)
        Request.find_each do |request|
          if request.subject_id == @event.subject_id
            user = User.find(request.user_id)
            user.send_requested_event_created(subject, @event)
            request.destroy
          end
        end
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
    params.require(:event).permit(:name, :subject_id, :description, :place, :cost, :date)
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
    unless event.any?
      flash[:info] = "This event has already occured and you can no longer view it."
      $redis.del('events')
      redirect_to root_url
    end
  end

end
