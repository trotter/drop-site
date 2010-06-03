require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get create" do
    get :create
    assert_response :redirect
  end

  test "should get finalize" do
    get :finalize
    assert_redirected_to websites_url
  end

end
