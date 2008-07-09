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
end
