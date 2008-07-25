require 'test_helper'

class NonceTest < ActiveSupport::TestCase
  fixtures :accounts
  
  should_belong_to :account
  should_have_indices :sid
  should_only_allow_numeric_values_for :user_id
  
  context 'a new nonce' do
    setup do
      @n = Nonce.create
    end
    
    should 'be valid right out of the gate' do
      assert_valid @n      
    end
    
    should 'create appropriately-sized nonce and sid' do
      assert_not_nil @n.nonce
      assert_not_nil @n.sid
      assert_equal 40, @n.nonce.length
      assert_equal 40, @n.sid.length
    end
    
    should 'only load with the correct signature' do
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
