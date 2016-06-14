require 'test_helper'

class SubjectsControllerTest < ActionController::TestCase

  test 'should not show subject when not logged in' do
    get :index
    assert_not flash.empty?
    assert_redirected_to login_url
  end

end
