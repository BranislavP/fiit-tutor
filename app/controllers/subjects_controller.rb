class SubjectsController < ApplicationController
  def index
    @subject = Subject.all.order(:level, :id)
  end
end
