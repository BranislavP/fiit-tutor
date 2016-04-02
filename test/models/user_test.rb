require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                      password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should not be empty" do
    @user.name = ""
    assert_not @user.valid?
    @user.name = "         "
    assert_not @user.valid?
  end

  test "email not empty" do
    @user.email = ""
    assert_not @user.valid?
    @user.email = "
"
    assert_not @user.valid?
  end

  test "name should not be long" do
    @user.name = "a" * 256
    assert_not @user.valid?
  end

  test "email shoudl not be long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email should be valid" do
    array = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn aaaa56@sdhjsfd.sdf]
    array.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address} should be valid"
    end
  end

  test "email that should not be valid" do
    array = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    array.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address} should not be valid"
    end
  end

  test "email is unique" do
    user2 = @user.dup
    user3 = @user.dup
    user3.email = @user.email.upcase
    @user.save
    assert_not user2.valid?
    assert_not user3.valid?
  end

  test "password should be present" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should be at least 6 characters" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  # test "the truth" do
  #   assert true
  # end
end
