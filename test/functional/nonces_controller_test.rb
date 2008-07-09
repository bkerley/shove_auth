require 'test_helper'

class NoncesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:nonces)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_nonce
    assert_difference('Nonce.count') do
      post :create, :nonce => { }
    end

    assert_redirected_to nonce_path(assigns(:nonce))
  end

  def test_should_show_nonce
    get :show, :id => nonces(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => nonces(:one).id
    assert_response :success
  end

  def test_should_update_nonce
    put :update, :id => nonces(:one).id, :nonce => { }
    assert_redirected_to nonce_path(assigns(:nonce))
  end

  def test_should_destroy_nonce
    assert_difference('Nonce.count', -1) do
      delete :destroy, :id => nonces(:one).id
    end

    assert_redirected_to nonces_path
  end
end
