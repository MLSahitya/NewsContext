require 'test_helper'

class FeedentriesControllerTest < ActionController::TestCase
  setup do
    @feedentry = feedentries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:feedentries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create feedentry" do
    assert_difference('Feedentry.count') do
      post :create, feedentry: { article: @feedentry.article, guid: @feedentry.guid, keywords: @feedentry.keywords, name: @feedentry.name, pubon: @feedentry.pubon, summary: @feedentry.summary, title: @feedentry.title, type: @feedentry.type, url: @feedentry.url }
    end

    assert_redirected_to feedentry_path(assigns(:feedentry))
  end

  test "should show feedentry" do
    get :show, id: @feedentry
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @feedentry
    assert_response :success
  end

  test "should update feedentry" do
    put :update, id: @feedentry, feedentry: { article: @feedentry.article, guid: @feedentry.guid, keywords: @feedentry.keywords, name: @feedentry.name, pubon: @feedentry.pubon, summary: @feedentry.summary, title: @feedentry.title, type: @feedentry.type, url: @feedentry.url }
    assert_redirected_to feedentry_path(assigns(:feedentry))
  end

  test "should destroy feedentry" do
    assert_difference('Feedentry.count', -1) do
      delete :destroy, id: @feedentry
    end

    assert_redirected_to feedentries_path
  end
end
