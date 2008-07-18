require 'test_helper'

class NoncesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:nonces)
  end

  def test_should_not_get_new
    get :new
    assert_response :missing
  end

  def test_should_not_create_nonce
    post :create, :nonce => { }
    
    assert_response :missing
  end

  def test_should_not_show_nonce
    get :show, :id => nonces(:one).id
    assert_response :missing
  end

  def test_should_not_get_edit
    get :edit, :id => nonces(:one).id
    assert_response :missing
  end

  def test_should_not_update_nonce
    put :update, :id => nonces(:one).id, :nonce => { }
    assert_response :missing
  end

  def test_should_destroy_nonce
    assert_difference('Nonce.count', -1) do
      delete :destroy, :id => nonces(:one).id
    end

    assert_redirected_to nonces_path
  end
end
