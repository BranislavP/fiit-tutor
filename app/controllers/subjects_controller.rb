class SubjectsController < ApplicationController
  def index
    @subject = Subject.find_by_sql("SELECT s.id, acronym, name, COUNT(r.id) FROM subjects s LEFT JOIN requests r ON s.id = r.subject_id GROUP BY s.id
                                   ORDER BY level, s.id")
  end
end
