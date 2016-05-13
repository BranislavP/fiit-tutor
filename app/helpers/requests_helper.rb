module RequestsHelper
  def requested?(subject, user)
    result = Request.where("user_id = #{user.id} AND subject_id = #{subject.id}")
    result.any?
  end
end
