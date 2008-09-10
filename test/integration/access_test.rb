require 'test_helper'
require 'socket'
require File.expand_path(File.dirname(__FILE__) + "/../../client/client.rb")

class AccessTest < ActionController::IntegrationTest
  fixtures :accounts

  context "with shove_auth on http://shove-auth.local/" do
    # bkerley/butt, allowed to poop, forbidden from toilet
    setup do
      ShoveAuth.site = "http://shove-auth.local/"
      @c = ShoveAuth::Client.new
    end
  
    context "as bkerley" do
      setup do
        @c.login 'bkerley', 'butt'
      end
    
      should "be allowed to appropriate resources" do
        assert @c.user.access?('acl://poop')
      end
    end
  end
end