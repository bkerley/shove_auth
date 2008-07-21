require 'test_helper'

class NoncesControllerTest < ActionController::TestCase
  context "without login" do
    should "fail to get index" do
      get :index
      assert_response 403
    end

    should "fail to get new form" do
      get :new
      assert_response 403
    end

    should "fail to create a nonce" do
      post :create, :nonce => { }

      assert_response 403
    end

    should "fail to show a nonce" do
      get :show, :id => nonces(:one).id
      assert_response 403
    end

   should "fail to get edit form" do
      get :edit, :id => nonces(:one).id
      assert_response 403
    end

    should "fail to update" do
      put :update, :id => nonces(:one).id, :nonce => { }
      assert_response 403
    end

    should "fail to destroy nonce" do
      delete :destroy, :id => nonces(:one).id

      assert_response 403
    end
  end

end
