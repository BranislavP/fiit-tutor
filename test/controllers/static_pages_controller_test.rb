require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  basetitle = "FIIT-Tutor"

  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", basetitle
  end

  test "should get help" do
    get :help
    assert_response :success
    assert_select "title", "Help | #{basetitle}"
  end

  test "should get about page" do
    get :about
    assert_response :success
    assert_select "title", "About | #{basetitle}"
  end

  test "should get contact" do
    get :contact
    assert_response :success
    assert_select "title", "Contact | #{basetitle}"
  end


end
