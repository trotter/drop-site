require 'test_helper'

class StatusControllerTest < ActionController::TestCase
  test "returns success when all systems are go" do
    get :show
    assert_response :success
  end
end
