require 'test_helper'

class CommentsControllerTest < ActionController::TestCase

  def setup
    @first_user = users(:michael)
    @second_user = users(:archer)
    @event = events(:dbs_event)
    @fcomment = comments(:first)
    @scomment = comments(:second)
  end

  test "should redirect create when not logged in" do
    @newcomment = Comment.new(content: 'Nieco', user_id: @first_user.id, event_id: @event.id)
    post :create, id: @newcomment, comment: {content: @newcomment.content, user_id: @newcomment.user_id, event_id: @newcomment.event_id}
    assert_redirected_to login_url
  end

  test 'should redirect delete when not logged in' do
    delete :destroy, id: @fcomment, event_id: @event
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should create new comment" do
    log_in_as(@first_user)
    @newcomment = Comment.new(content: 'Nieco', user_id: @first_user.id, event_id: @event.id)
    post :create, id: @newcomment, comment: {content: @newcomment.content, user_id: @newcomment.user_id, event_id: @newcomment.event_id}
    assert_not flash.empty?
    assert_redirected_to @event
  end

  test 'should delete comment' do
    log_in_as(@first_user)
    delete :destroy, id: @fcomment, event_id: @event
    assert flash.empty?
    assert_redirected_to @event
  end

end
