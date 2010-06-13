require 'test_helper'

class WebsitesControllerTest < ActionController::TestCase
  setup do
    login
  end
  
  test "should get index" do
    get :index
    assert_response :success
  end
end
