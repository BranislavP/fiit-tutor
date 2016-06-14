require 'test_helper'

class RequestsControllerTest < ActionController::TestCase

  def setup
    @fuser = users(:michael)
    @suser = users(:archer)
    @subject = subjects(:vos)
    @myrequest = requests(:first)
  end

  test 'should redirect destroy when not logged in' do
    delete :destroy, id: @myrequest
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect create when not logged in' do
    nreq = Request.new(user_id: @fuser, subject_id: @subject)
    post :create, id: nreq, request: { user_id: nreq.user_id, subject_id: nreq.subject_id }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'cannot have more then one request in one subject' do
    log_in_as(@suser)
    nreq = Request.new(user_id: @suser, subject_id: @subject.id)
    assert_no_difference 'Request.count' do
      post :create, id: nreq.id, subject_id: nreq.subject_id, request: { user_id: nreq.user_id }
    end
    assert flash.empty?
    assert_redirected_to subjects_path
  end

end
