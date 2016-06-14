require 'test_helper'

class RatingTest < ActiveSupport::TestCase

  def setup
    @one = users(:michael)
    @two = users(:archer)
    @rating = Rating.new(content: 'Something', score: 2, user_id: @one.id, tutor_id: @two.id)
  end

  test "should be valid" do
    assert @rating.valid?
  end

  test "content should be present" do
    @rating.content = ""
    assert_not @rating.valid?
    @rating.content = "     "
    assert_not @rating.valid?
  end

  test "score should be between 0 and 10" do
    @rating.score = 10
    assert @rating.valid?
    @rating.score = 11
    assert_not @rating.valid?
    @rating.score = -1
    assert_not @rating.valid?
  end

end
