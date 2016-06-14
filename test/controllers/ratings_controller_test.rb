require 'test_helper'

class RatingsControllerTest < ActionController::TestCase

  def setup
    @rating = ratings(:first)
    @fuser = users(:lana)
    @suser = users(:malory)
  end

  test 'should redirect delete when not logged in' do
    delete :destroy, id: @rating
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should not rate when not logged in' do
    nrating = Rating.new(score: 5, content: 'Very good', user_id: @suser, tutor_id: @fuser)
    post :create, id: nrating, rating: { score: nrating.score, content: nrating.content, user_id: nrating.user_id, tutor_id: nrating.tutor_id }
    assert_not flash.empty?
    assert_redirected_to login_url
  end



end
