require 'test_helper'

class EventTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @subject = subjects(:dbs)
    @event = Event.new(name: 'Event o DBS', description: 'Nieco', place: 'FIIT STU', date: Time.zone.tomorrow, cost: 8,
                       user_id: @user.id, subject_id: @subject.id)
  end

  test "should be valid" do
    assert @event.valid?
  end

  test "name should not be empty" do
    @event.name = ""
    assert_not @event.valid?
    @event.name = "    "
    assert_not @event.valid?
  end

  test "name should not be long" do
    @event.name = 'a' * 256
    assert_not @event.valid?
  end

  test "description should not be empty" do
    @event.description = ""
    assert_not @event.valid?
    @event.description = "    "
    assert_not @event.valid?
  end

  test "place should be specified" do
    @event.place = ""
    assert_not @event.valid?
    @event.place = "    "
    assert_not @event.valid?
  end

  test "cost should not be high" do
    @event.cost = 20
    assert @event.valid?
    @event.cost = 21
    assert_not @event.valid?
  end

  test "cost should not be negative" do
    @event.cost = 0
    assert @event.valid?
    @event.cost = -1
    assert_not @event.valid?
  end


end
