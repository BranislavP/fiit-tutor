require 'test_helper'

class EventUsersControllerTest < ActionController::TestCase

  def setup
    @fuser = users(:michael)
    @suser = users(:archer)
    @fevent = events(:dbs_event)
    @sevent = events(:dsa_event)
    @fattend = event_users(:first)
    @sattend = event_users(:second)
  end

  test 'should redirect signup when not logged in' do
    newsign = EventUser.new(user_id: @fuser.id, event_id: @sevent.id)
    post :create, id: newsign, event_user: { user_id: newsign.user_id, event_id: newsign.event_id }
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test 'should redirect delete when not logged in' do
    delete :destroy, id: @fattend
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test 'attend destroy followed by new attend' do
    log_in_as(@fuser)
    delete :destroy, id: @fevent
    assert_not flash.empty?
    assert_redirected_to @fevent
    newsign = EventUser.new(user_id: @fuser.id, event_id: @fevent.id)
    post :create, id: newsign, event_user: { user_id: newsign.user_id, event_id: newsign.event_id }
    assert_not flash.empty?
    assert_redirected_to @fevent
  end

  test 'event creator should not sign up' do
    log_in_as(@suser)
    newsign = EventUser.new(user_id: @suser.id, event_id: @sevent.id)
    post :create, id: newsign, event_user: { user_id: newsign.user_id, event_id: newsign.event_id }
    assert flash.empty?
    eu = EventUser.find_by(user_id: @suser.id, event_id: @sevent.id)
    assert eu.nil?
    assert_redirected_to root_url
  end

  test 'cannot attend more than once' do
    log_in_as(@fuser)
    newsign = EventUser.new(user_id: @fuser.id, event_id: @fevent.id)
    post :create, id: newsign, event_user: { user_id: newsign.user_id, event_id: newsign.event_id }
    assert_not flash.empty?
    assert_redirected_to root_url
  end

end
