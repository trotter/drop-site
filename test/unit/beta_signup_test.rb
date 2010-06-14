require 'test_helper'

class BetaSignupTest < ActiveSupport::TestCase
  setup do
    @beta_signup = BetaSignup.new(:email => "test@example.com")
  end

  test "is normally valid" do
    assert @beta_signup.valid?, @beta_signup.errors.full_messages
  end

  test "requires email" do
    @beta_signup.email = nil
    assert !@beta_signup.valid?
  end

  test "requires the email address to be valid" do
    @beta_signup.email = "blah"
    assert !@beta_signup.valid?
  end

  test "requires the email address to be unique" do
    @beta_signup.save
    invalid = BetaSignup.new(:email => @beta_signup.email)
    assert !invalid.valid?
  end
end
