require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  def setup
    params = {:username=>'bkerley', :password=>'butt'}
    @account = Account.new(params)
    @account.save
  end
  
  def test_creation
    a = Account.find_by_username('bkerley')
    assert_equal a.id, @account.id
  end
  
  def test_hashing
    myhash = "jK+2mdV5UlqMcoet5RmsqejZ7Gs="
    assert_equal Account.digest('bkerley', 'butt'), myhash
    assert_equal @account.digest, myhash
    assert @account.check_digest(myhash)
  end
end
