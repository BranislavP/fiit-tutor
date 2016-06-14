class RequestsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action   :not_requested, only: [:create]
  before_action   :requested    , only: [:destroy]

  def create
    @request = current_user.requests.build(request_params)
    if @request.save
      flash[:success] = "Request acknowledged."
    else
      flash[:danger] = "Could not sent request."
    end
      redirect_to subjects_path
  end

  def destroy
    Request.find_by(user_id: current_user.id, subject_id: params[:id]).destroy
    flash[:success] = "Request deleted"
    redirect_to subjects_path
  end

  private

  def request_params
    params.permit(:subject_id, :user_id)
  end

  def not_requested
    request = Request.find_by(user_id: current_user.id, subject_id: params[:subject_id])
    redirect_to subjects_path unless request.nil?
  end

  def requested
    request = Request.find_by(user_id: current_user.id, subject_id: params[:id])
    redirect_to subjects_path if request.nil?
  end
end
