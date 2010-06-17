require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get not create without correct super_sekret" do
    get :create, :super_sekret => "blippityBloop"
    assert_response :redirect
    assert_redirected_to root_url
    assert_equal "You can't do that! Sign-up instead :-)", flash[:errors]
  end

  test "should get create only if correct super_sekret is there" do
    get :create, :super_sekret => "awesomeTown"
    assert_response :redirect
  end

  test "should get finalize" do
    get :finalize
    assert_redirected_to websites_url
  end

end
