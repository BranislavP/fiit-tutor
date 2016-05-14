module EventUsersHelper

  def signed_in?(user, event)
    sign = EventUser.find_by(user_id: user.id, event_id: event.id)
    !sign.nil? || user.id == event.user_id
  end

  def outdated?(event)
    sign = Event.where("id = #{event.id} AND EXTRACT(epoch FROM(date - CURRENT_TIMESTAMP)) > 0")
    !sign.any?
  end
end
