require 'test_helper'

class EventUserTest < ActiveSupport::TestCase

  def setup
    @user = users(:archer)
    @event = events(:dsa_event)
    @event_user = EventUser.new(user_id: @user.id, event_id: @event.id)
  end

  test "only one signup on any event" do
    eu = @event_user.dup
    assert eu.valid?
    @event_user.save
    assert_not eu.valid?
  end

end
