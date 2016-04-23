require 'will_paginate/array'

class StaticPagesController < ApplicationController
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
end
