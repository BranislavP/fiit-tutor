class SubjectsController < ApplicationController
  before_action :logged_in_user, only: :index

  def index
    @subject = Subject.find_by_sql("SELECT s.id, acronym, name, COUNT(r.id) FROM subjects s LEFT JOIN requests r ON s.id = r.subject_id GROUP BY s.id
                                   ORDER BY count DESC, level, s.id")
  end
end
