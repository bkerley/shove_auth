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

  context 'with admin credentials' do
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
    
    context 'changing own password' do
      setup do
        request_xml
        @old_digest = @nonce.account.digest
        @new_pass = Nonce.rand_bytes
        put :update, {:id=>@username, :password=>@new_pass, 
          :session=>{:sid=>@nonce.sid, :hmac=>Nonce.hmac(@nonce.session_secret, "PUT /user/#{@username} #{@nonce.sid} #{@new_pass}")}}
      end
      
      should_respond_with :success
      should 'have changed the digest' do
        @nonce.account.reload
        assert_not_equal @old_digest, @nonce.account.digest
      end
    end
    
    context 'changing other password' do
      setup do
        request_xml
        @target = Account.find_by_username 'failure'
        @old_digest = @target.digest
        @new_pass = Nonce.rand_bytes
        put :update, {:id=>@target.username, :password=>@new_pass,
          :session=>{:sid=>@nonce.sid, :hmac=>Nonce.hmac(@nonce.session_secret, "PUT /user/#{@target.username} #{@nonce.sid} #{@new_pass}")}}
      end
      
      should_respond_with :success
      should 'have changed the digest' do
        @target.reload
        assert_not_equal @old_digest, @target.digest
      end
    end
    
    context 'create user' do
      setup do
        request_xml
        @new_username = Namegen.screenname
        post :create, {:id=>@new_username,
          :session=>{:sid=>@nonce.sid, :hmac=>Nonce.hmac(@nonce.session_secret, "POST /user/#{@new_username} #{@nonce.sid}")}}
      end
      
      should_respond_with :created
      should 'have created the user' do
        user = Account.find_by_username @new_username
        assert user
        assert_valid user
      end
    end
    
    context 'destroy user' do
      setup do
        request_xml
        delete :destroy, {:id=>'failure',
          :session=>{:sid=>@nonce.sid, :hmac=>Nonce.hmac(@nonce.session_secret, "DELETE /user/failure #{@nonce.sid}")}}
      end
      
      should_respond_with :ok
      should 'destroy the user' do
        user = Account.find_by_username 'failure'
        assert_nil user
      end
    end
  end
end
