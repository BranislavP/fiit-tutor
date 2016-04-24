module EventUsersHelper

  def signed_in?(user, event)
    sign = EventUser.find_by(user_id: user.id, event_id: event.id)
    !sign.nil?
  end
end
