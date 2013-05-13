require 'test_helper'

class DataclearControllerTest < ActionController::TestCase
  test "should get srcclear" do
    get :srcclear
    assert_response :success
  end

  test "should get artclear" do
    get :artclear
    assert_response :success
  end

  test "should get clusclear" do
    get :clusclear
    assert_response :success
  end

end
