require 'test_helper'

class UserControllerTest < ActionController::TestCase
  context 'without credentials' do
    context 'on GET' do
      setup do
        get :show, :id=>'invalid'
      end
      should_respond_with 403
    end
    context 'on PUT' do
      setup do
        put :update, :id=>'invalid'
      end
      should_respond_with 403
    end
    context 'on DELETE' do
      setup do
        put :destroy, :id=>'invalid'
      end
      should_respond_with 403
    end
    context 'on POST' do
      setup do
        post :create, :id=>'invalid'
      end
      should_respond_with 403
    end
  end

  context 'with credentials' do
    setup do
      @nonce = Nonce.find(3)
      @username = @nonce.account.username
    end
    
    context 'show user' do
      setup do
        request_xml
        get :show, {:id=>@username, :session=>{:sid=>@nonce.sid, :hmac=>Nonce.hmac(@nonce.session_secret, "GET /user/#{@username} #{@nonce.sid}")}}
      end
      
      should_respond_with :success
      should_respond_with_xml_for :account
    end
    
    context 'update user' do
      setup do
        request_xml
        @old_digest = @nonce.account.digest
        @new_pass = Nonce.rand_bytes
        put :update, {:id=>@username, :password=>@new_pass, 
          :session=>{:sid=>@nonce.sid, :hmac=>Nonce.hmac(@nonce.session_secret, "PUT /user/#{@username} #{@nonce.sid} #{@new_pass}")}}
      end
      
      should_respond_with :success
      should_respond_with_xml_for :account
      should 'have changed the digest' do
        assert_not_equal @old_digest, @nonce.account.digest
      end
    end
  end
end
