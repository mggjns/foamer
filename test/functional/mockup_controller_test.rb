require 'test_helper'

class MockupControllerTest < ActionController::TestCase
  test "should get welcome" do
    get :welcome
    assert_response :success
  end

  test "should get home" do
    get :home
    assert_response :success
  end

  test "should get preferences" do
    get :preferences
    assert_response :success
  end

  test "should get event" do
    get :event
    assert_response :success
  end

  test "should get transit" do
    get :transit
    assert_response :success
  end

  test "should get alert" do
    get :alert
    assert_response :success
  end

end
