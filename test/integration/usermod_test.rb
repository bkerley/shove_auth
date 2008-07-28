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
      should 'show myself' do
        assert @c.user
        assert_equal 'bkerley', @c.user.username
      end
      should 'change own password' do
        @c.user.set_password 'bloat'
        assert_equal :authenticated, ShoveAuth::login('bkerley', 'bloat')
        @c.user.set_password 'butt'
        assert_equal :authenticated, ShoveAuth::login('bkerley', 'butt')
      end
      should "change failure's password" do
        @c['failure'].set_password 'successful'
        assert_equal :authenticated, ShoveAuth::login('failure', 'successful')
        @c['failure'].set_password 'failure'
        assert_equal :authenticated, ShoveAuth::login('failure', 'failure')
      end
      should 'create and destroy a pal for failure' do
        tempname = Namegen.screenname + '_TEMP'
        @c.create tempname
        @c[tempname].set_password 'winner'
        assert_equal :authenticated, ShoveAuth::login(tempname, 'winner')
        @c[tempname].destroy
        assert !ShoveAuth::login(tempname,'winner')
      end
    end
  end
end