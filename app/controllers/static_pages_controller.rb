require 'will_paginate/array'

class StaticPagesController < ApplicationController
  before_action :admin_user, only: [:reset_visits]

  def home
    if logged_in?
      #@events = Event.find_by_sql("SELECT * FROM events ORDER BY created_at DESC").paginate(page: params[:page])
      events = $redis.get('events')
      if events.nil?
        events = Event.all.to_json
        $redis.set('events', events)
      end
      #@events = Event.all.paginate(page: params[:page])
      @events = JSON.load events
      @events = @events.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end

  def reset_visits
    events = Event.all
    events.each do |event|
      $redis.expire(event.id, 1)
    end
    flash[:success] = "Visit reset!"
    redirect_to root_url
  end

  private

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
