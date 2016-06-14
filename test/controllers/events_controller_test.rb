require 'test_helper'

class EventsControllerTest < ActionController::TestCase

  def setup
    @event = events(:dbs_event)
    @user = users(:michael)
    @subject = subjects(:dsa)
    @outdated = events(:vos_event)
  end

  test 'should redirect show when not logged in' do
    get :show, id: @event
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect delete when not logged in' do
    delete :destroy, id: @event
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect create when not logged in' do
    nevent = Event.new(name: 'Event', description: 'Desc', cost: 8, user_id: @user, subject_id: @subject, date: Time.zone.tomorrow, place: 'FIIT' )
    post :create, id: nevent, event: { name: nevent.name, description: nevent.description, cost: nevent.cost,
                                       user_id: nevent.user_id, subject_id: nevent.subject_id, date: nevent.date, place: nevent.place }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should not destroy others events' do
    log_in_as(@user)
    delete :destroy, id: @event
    assert flash.empty?
    e = Event.find_by(id: @event.id)
    assert_not e.nil?
    assert_redirected_to root_url
  end

  test 'should not delete or show outdated events' do
    log_in_as(@user)
    get :show, id: @outdated
    assert_not flash.empty?
    assert_redirected_to root_url
    delete :destroy, id: @outdated
    assert_not flash.empty?
    assert_not Event.find_by(id: @outdated).nil?
    assert_redirected_to root_url
  end

end
