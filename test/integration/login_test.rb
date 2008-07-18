require 'test_helper'
require File.expand_path(File.dirname(__FILE__) + "/../../client/client.rb")

class LoginTest < ActionController::IntegrationTest
  fixtures :accounts
  
  def test_simple_authentication
    assert_equal :authenticated, ShoveAuth::login('bkerley', 'butt')
  end
  
  def test_stateful_authentication
    c = ShoveAuth::Client.new
    assert_equal :authenticated, c.login('bkerley','butt')
    assert_equal 'bkerley', c.username
  end
  
  def test_authentication_fail
    assert !ShoveAuth::login('bkerley','invalid')
    assert !ShoveAuth::Client.new.login('bkerley','invaild')
  end
end