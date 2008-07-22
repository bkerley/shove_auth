require 'test_helper'
require 'socket'
require File.expand_path(File.dirname(__FILE__) + "/../../client/client.rb")

class LoginTest < ActionController::IntegrationTest
  fixtures :accounts
  
  context "authenticating against a server that doesn't exist" do
    setup do
      ShoveAuth.site = "http://invalid/"
    end
    
    should "fail" do
      assert_raise(SocketError) { ShoveAuth::login('asdf','asdf') }
      assert_raise(SocketError) { ShoveAuth::Client.new.login('fdsa','fdsa') }
    end
  end
  
  context "with shove_auth on http://shove-auth.local/ and testing user bkerley/butt" do
    setup do
      ShoveAuth.site = "http://shove-auth.local/"
    end
    
    should "authenticate simply" do
      assert_equal :authenticated, ShoveAuth::login('bkerley', 'butt')
    end
    
    should "authenticate statefully" do
      c = ShoveAuth::Client.new
      assert_equal :authenticated, c.login('bkerley','butt')
      assert_equal 'bkerley', c.username
    end
    
    should "fail when authenticating with the wrong password" do
      assert !ShoveAuth::login('bkerley','invalid')
      assert !ShoveAuth::Client.new.login('bkerley','invaild')
    end
    
    should "fail when authenticating with no user" do
      assert !ShoveAuth::login('bkerleyxxx','invalid')
      assert !ShoveAuth::Client.new.login('bkerleyxxx','invaild')
    end
  end
end