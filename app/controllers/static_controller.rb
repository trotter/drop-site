class StaticController < ApplicationController
  def welcome
    @beta_signup = BetaSignup.new(flash.fetch(:params, {})[:beta_signup])
  end

end
