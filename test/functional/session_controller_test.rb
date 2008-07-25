require 'test_helper'

class SessionControllerTest < ActionController::TestCase
  context "on POST to create" do
    setup do
      request_xml
      post :create
    end
    
    should_not_set_the_flash
    should_respond_with :success
    should_respond_with_xml_for 'nonce'
  end
end
