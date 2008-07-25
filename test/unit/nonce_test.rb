require 'test_helper'

class NonceTest < ActiveSupport::TestCase
  fixtures :accounts
  
  should_belong_to :account
  should_require_unique_attributes :nonce
  should_require_unique_attributes :sid
  should_only_allow_numeric_values_for :user_id
  
  context 'a new nonce' do
    setup do
      @n = Nonce.new
      @n.save
    end
    
    should 'create appropriately-sized nonce and sid' do
      assert_not_nil @n.nonce
      assert_not_nil @n.sid
      assert_not_equal @n.nonce, 'MyString'
      assert_not_equal @n.sid, 'MyString'
      assert_in_delta @n.nonce.length, 40, 2
      assert_in_delta @n.sid.length, 40, 2
    end
    
    should 'load with correct signature' do
      nonce = @n.nonce
      sid = @n.sid
      user = Account.find_by_username 'bryce'
      message = "PUT /session/#{sid} #{nonce}"
      secret = user.digest
      hmac = Nonce.hmac(secret, message)

      assert !Nonce.load_nonce(sid, user.username, 'fart')
      assert !Nonce.load_nonce(sid, 'fart', hmac)
      assert !Nonce.load_nonce('fart', user.username, hmac)

      result = Nonce.load_nonce(sid, user.username, hmac)
      assert result
      assert_equal result.account.id, user.id
    end
    
  end
end
