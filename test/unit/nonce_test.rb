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
  
  context 'rand_bytes' do
    should 'output forty bytes' do
      # can't actually test for randomness
      b = Nonce.rand_bytes
      assert_equal 40, b.length
    end
    
    should 'be url-safe' do
      b = Nonce.rand_bytes
      assert !(b.include? '/')
      assert !(b.include? '+')
    end
  end
  
  should 'hmac correctly' do
    vectors = [
      # examples from appendix A of FIPS-198a
      # http://csrc.nist.gov/publications/fips/fips198/fips-198a.pdf
      {:k=>(0x00..0x3f), :t => 'Sample #1', :c=>'4f4ca3d5d68ba7cc0a1208c9c61e9c5da0403c0a'},
      {:k=>(0x30..0x43), :t => 'Sample #2', :c=>'0922d3405faa3d194f82a45830737d5cc6c75d24'},
      {:k=>(0x50..0xb3), :t => 'Sample #3', :c=>'bcf41eab8bb2d802f3d05caf7cb092ecf8d1a3aa'}
    ]
    vectors.each do |v|
      k = v[:k].map{|e|e.chr}.join('')
      t = v[:t]
      c = v[:c]
      assert_equal c, Nonce.hmac(k,t)
    end
  end
end
