require 'test_helper'

class MembershipsControllerTest < ActionController::TestCase
  context 'without credentials' do
    context 'on GET' do
      setup do
        get :show, :id=>'invalid'
      end
      should_respond_with 403
    end
    context 'on PUT' do
      setup do
        put :update, :id=>'invalid'
      end
      should_respond_with 403
    end
    context 'on DELETE' do
      setup do
        put :destroy, :id=>'invalid'
      end
      should_respond_with 403
    end
    context 'on POST' do
      setup do
        post :create, :id=>'invalid'
      end
      should_respond_with 403
    end
  end
  
  should_eventually 'have credentialed tests'
end
