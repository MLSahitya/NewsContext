require 'test_helper'

class SentimentControllerTest < ActionController::TestCase
  test "should get calculate" do
    get :calculate
    assert_response :success
  end

  test "should get display" do
    get :display
    assert_response :success
  end

end
