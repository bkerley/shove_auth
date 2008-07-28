require 'test_helper'
require 'socket'
require File.expand_path(File.dirname(__FILE__) + "/../../client/client.rb")

class UsermodTest < ActionController::IntegrationTest
  fixtures :accounts
  
  context "with shove_auth on http://shove-auth.local/" do
    # bkerley/butt and failure/failure
    setup do
      ShoveAuth.site = "http://shove-auth.local/"
      @c = ShoveAuth::Client.new
    end
    
    context "as an admin" do
      setup do
        @c.login 'bkerley', 'butt'
      end
      should 'change own password' do
        @c.password = 'bloat'
        assert_equal :authenticated, ShoveAuth::login('bkerley', 'bloat')
      end
      should "change failure's password" do
        @c['failure'].password = 'successful'
        assert_equal :authenticated, ShoveAuth::login('failure', 'successful')
      end
      should 'create a pal for failure' do
        @c.create 'loser'
        @c['loser'].password = 'winner'
        assert_equal :authenticated, ShoveAuth::login('loser', 'winner')
      end
    end
  end
end