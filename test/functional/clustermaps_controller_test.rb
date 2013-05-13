require 'test_helper'

class ClustermapsControllerTest < ActionController::TestCase
  setup do
    @clustermap = clustermaps(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:clustermaps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create clustermap" do
    assert_difference('Clustermap.count') do
      post :create, clustermap: { clusid: @clustermap.clusid, name: @clustermap.name }
    end

    assert_redirected_to clustermap_path(assigns(:clustermap))
  end

  test "should show clustermap" do
    get :show, id: @clustermap
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @clustermap
    assert_response :success
  end

  test "should update clustermap" do
    put :update, id: @clustermap, clustermap: { clusid: @clustermap.clusid, name: @clustermap.name }
    assert_redirected_to clustermap_path(assigns(:clustermap))
  end

  test "should destroy clustermap" do
    assert_difference('Clustermap.count', -1) do
      delete :destroy, id: @clustermap
    end

    assert_redirected_to clustermaps_path
  end
end
