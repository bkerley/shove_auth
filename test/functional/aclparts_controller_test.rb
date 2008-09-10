require 'test_helper'

class AclpartsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:aclparts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create aclpart" do
    assert_difference('Aclpart.count') do
      post :create, :aclpart => { }
    end

    assert_redirected_to aclpart_path(assigns(:aclpart))
  end

  test "should show aclpart" do
    get :show, :id => aclparts(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => aclparts(:one).id
    assert_response :success
  end

  test "should update aclpart" do
    put :update, :id => aclparts(:one).id, :aclpart => { }
    assert_redirected_to aclpart_path(assigns(:aclpart))
  end

  test "should destroy aclpart" do
    assert_difference('Aclpart.count', -1) do
      delete :destroy, :id => aclparts(:one).id
    end

    assert_redirected_to aclparts_path
  end
end
