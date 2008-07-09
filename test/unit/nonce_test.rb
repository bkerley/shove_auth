require 'test_helper'

class NonceTest < ActiveSupport::TestCase
  fixtures :accounts
  
  def setup
    @n = Nonce.new
    @n.save
  end
  
  def test_creation_generators
    assert_not_nil @n.nonce
    assert_not_nil @n.sid
    assert_not_equal @n.nonce, 'MyString'
    assert_not_equal @n.sid, 'MyString'
    assert_in_delta @n.nonce.length, 40, 2
    assert_in_delta @n.sid.length, 40, 2
  end
  
  def test_load_user
    nonce = @n.nonce
    sid = @n.sid
    user = Account.find_by_username 'bryce'
    message = "PUT /session/#{sid} #{nonce}"
    secret = user.digest
    hmac = Nonce.hmac(secret, message)
    
    assert !Nonce.load_user(sid, user.username, 'fart')
    assert !Nonce.load_user(sid, 'fart', hmac)
    assert !Nonce.load_user('fart', user.username, hmac)
    
    result = Nonce.load_user(sid, user.username, hmac)
    assert result
    assert_equal result.id, user.id
  end
  
end
