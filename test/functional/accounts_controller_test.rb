require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  context "without login" do
    should "fail to get index" do
      get :index
      assert_response 403
    end

    should "fail to get new form" do
      get :new
      assert_response 403
    end

    should "fail to create account" do
      post :create, :account => { }

      assert_response 403
    end

    should "fail to show account" do
      get :show, :id => accounts(:one).id
      assert_response 403
    end

    should "fail to get edit form" do
      get :edit, :id => accounts(:one).id
      assert_response 403
    end

    should "fail to update account" do
      put :update, :id => accounts(:one).id, :account => { }
      assert_response 403
    end

    should "fail to destroy account" do
      delete :destroy, :id => accounts(:one).id
      assert_response 403
    end
  end
end
