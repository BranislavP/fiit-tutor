class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def outdated
    id = params[:id]
    if id.nil?
      id = params[:event_user][:event_id]
    end
    event = Event.where("id = ? AND EXTRACT(epoch FROM(date - CURRENT_TIMESTAMP)) > 0", id)
    redirect_to root_url unless event.any?
  end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

end
