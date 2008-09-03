require 'test_helper'
require 'socket'
require File.expand_path(File.dirname(__FILE__) + "/../../client/client.rb")

class LegacyTest < ActionController::IntegrationTest
  fixtures :accounts
  
  context "with shove_auth on http://shove-auth.local/" do
    # bkerley/butt and failure/failure
    setup do
      ShoveAuth.site = "http://shove-auth.local/"
      @c = ShoveAuth::Client.new
    end
    
    context "as a user" do
      setup do
        @c.login 'bkerley', 'butt'
      end
      
      should "successfully make a legacy user" do
        assert_kind_of ShoveAuth::LegacyUser, @c.user.to_legacy_object
      end
    end
  end
end