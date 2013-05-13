require 'test_helper'

class DatastoreControllerTest < ActionController::TestCase
  test "should get srcstore" do
    get :srcstore
    assert_response :success
  end

  test "should get artstore" do
    get :artstore
    assert_response :success
  end

end
