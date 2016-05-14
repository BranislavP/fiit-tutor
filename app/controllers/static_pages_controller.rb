require 'will_paginate/array'

class StaticPagesController < ApplicationController
  before_action :admin_user, only: [:reset_visits]

  def home
    if logged_in?
      if params[:subject_search] && params[:subject_search] != "" && params[:subject_search].to_i > 0
        q = params[:subject_search].to_i
        @events = Event.find_by_sql("SELECT e.id, e.name, coalesce(AVG(score), 10) AS score FROM events e LEFT JOIN users u ON u.id = e.user_id
                                   LEFT JOIN ratings r ON u.id = r.tutor_id WHERE EXTRACT(epoch FROM(date + interval '1 day' - CURRENT_TIMESTAMP)) > 0
                                   AND e.subject_id = #{q} GROUP BY u.id, e.id ORDER BY e.created_at DESC").paginate(page: params[:page])
      else
        events = $redis.get('events')
        if events.nil?
          events = Event.find_by_sql("SELECT e.id, e.name, coalesce(AVG(score), 10) AS score FROM events e LEFT JOIN users u ON u.id = e.user_id
                                   LEFT JOIN ratings r ON u.id = r.tutor_id WHERE EXTRACT(epoch FROM(date + interval '1 day' - CURRENT_TIMESTAMP)) > 0
                                   GROUP BY u.id, e.id ORDER BY e.created_at DESC").to_json
          $redis.set('events', events)
          $redis.expire('events', 1.day)
        end
        @events = JSON.load events
        @events = @events.paginate(page: params[:page])
      end
    end
  end

  def help
  end

  def about
  end

  def contact
  end

  def reset_visits
    Event.find_each do |event|
      $redis.del(event.id)
    end
    flash[:success] = "Visit reset!"
    redirect_to root_url
  end

end
