require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  should_have_many :nonces
  
  context 'a new account' do
    setup do
      params = {:username=>'bkerley', :password=>'butt'}
      @account = Account.new(params)
      @account.save
    end
    
    should 'have been created' do
      a = Account.find_by_username('bkerley')
      assert_equal a.id, @account.id
    end
    
    should 'hash correctly' do
        myhash = "jK+2mdV5UlqMcoet5RmsqejZ7Gs="
        assert_equal Account.digest('bkerley', 'butt'), myhash
        assert_equal @account.digest, myhash
        assert @account.check_password('butt')
        assert @account.check_digest(myhash)
    end
    
    context 'getting destroyed' do
      should 'be destroyed' do
        @account.destroy
        assert_nil Account.find_by_username('bkerley')
      end
      
      should 'cascade-destroy its nonces' do
        n = Nonce.create(:account=>@account)
        assert_equal @account, n.account
        assert_not_nil Nonce.find(n.id)
        @account.destroy
        assert_raise(ActiveRecord::RecordNotFound){Nonce.find(n.id)}
      end
    end
  end
end
