require 'test_helper'

class SessionControllerTest < ActionController::TestCase
  context 'on POST to create' do
    setup do
      request_xml
      post :create
    end
    
    should_not_set_the_flash
    should_respond_with :success
    should_respond_with_xml_for 'nonce'
  end
  
  context 'on PUT with invalid sid' do
    setup do
      request_xml
      put :update, :id=>'invalid'
    end
    
    should_respond_with 403
  end
  
  context 'on PUT with valid sid' do
    setup do
      request_xml
      u = Account.find_by_username 'bryce'
      put :update, :id=>'MyString1',
        :session=>{:username=>u.username, :hmac=>Nonce.hmac(u.digest, "PUT /session/MyString1 MyString1")}
      
      @nonce = Hash.from_xml(@response.body)['nonce']
    end
    
    should_not_set_the_flash
    should_respond_with :success
    should_respond_with_xml_for 'nonce'
    should 'provide an adequate session_secret' do
      assert(secret = @nonce['session_secret'])
      assert_equal 40, secret.length
    end
    
    should 'say whether we actually authenticated' do
      assert_equal :authenticated, @nonce['state']
    end
  end
end
