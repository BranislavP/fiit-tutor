require 'will_paginate/array'

class StaticPagesController < ApplicationController
  before_action :admin_user, only: [:reset_visits]

  def home
    if logged_in?
      events = $redis.get('events')
      if events.nil?
        events = Event.where("EXTRACT (epoch FROM(date - CURRENT_TIMESTAMP)) > 0").to_json
        $redis.set('events', events)
        $redis.expire('events', 1.day)
      end
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

end
