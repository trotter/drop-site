require 'test_helper'

class WebsitesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
