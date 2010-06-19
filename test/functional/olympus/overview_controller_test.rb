require 'test_helper'

class Olympus::OverviewControllerTest < ActionController::TestCase
  setup do
    @controller.expects(:digest_authentication)
  end

  test "should show an overview" do
    get :show
    assert_response :success
  end
end
