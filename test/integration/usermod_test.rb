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
      should 'work with a user with an email address as their username' do
        tempname = Namegen.screenname + '@worldmedia._TEMP'
        @c.create tempname
        @c[tempname].set_password 'emailah'
        assert_equal :authenticated, ShoveAuth::login(tempname, 'emailah')
        @c[tempname].destroy
        assert !ShoveAuth::login(tempname, 'emailiah')
      end
    end
    
    context "as a non-admin" do
      setup do
        @c.login 'failure', 'failure'
      end
      should 'show myself' do
        assert @c.user
        assert_equal 'failure', @c.user.username
      end
      should 'change own password' do
        @c.user.set_password 'bloat'
        assert_equal :authenticated, ShoveAuth::login('failure', 'bloat')
        @c.user.set_password 'failure'
        assert_equal :authenticated, ShoveAuth::login('failure', 'failure')
      end
      should 'fail to create a user' do
        assert_raise(ShoveAuth::Error){@c.create(Namegen.screenname + '_TEMP')}
      end
      should 'fail to load bryce' do
        assert_nil @c['bryce']
      end
    end
  end
end