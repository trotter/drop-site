require 'test_helper'

class BetaSignupsControllerTest < ActionController::TestCase
  test "should create a beta signup" do
    assert_difference "BetaSignup.count" do
      post :create, :beta_signup => { :email => "test@example.com" }
      assert_response :redirect
      assert_not_nil flash[:success]
    end
  end

  test "should redirect to root with an error message on failed signup" do
    params = { :beta_signup => { :email => "so bad" }}
    BetaSignup.any_instance.stubs(:valid?).returns false
    assert_no_difference "BetaSignup.count" do
      post :create, params
      assert_response :redirect
      assert_not_nil flash[:errors]
      assert_equal   params[:beta_signup][:email],
                     flash[:params][:beta_signup][:email]
    end
  end
end
