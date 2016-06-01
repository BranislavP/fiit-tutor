module RequestsHelper
  def requested?(subject, user)
    result = Request.where("user_id = ? AND subject_id = ?", user.id, subject.id)
    result.any?
  end
end
