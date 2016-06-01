module RatingsHelper

  def attended_event?(user)
    return false if user.id == current_user.id
    rating = Rating.find_by(user_id: current_user.id, tutor_id: user.id)
    return false unless rating.nil?
    attendance = EventUser.find_by_sql(["SELECT * FROM event_users eu JOIN users u ON u.id = eu.user_id JOIN events e ON e.id = eu.event_id
                  WHERE u.id = ? AND e.user_id = ? AND EXTRACT (epoch FROM(date - CURRENT_TIMESTAMP)) < 0", current_user.id, user.id])
    attendance.any?
  end

end
