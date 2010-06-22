class BetaSignupsController < ApplicationController
  def show
  end

  def create
    @signup = BetaSignup.new(params[:beta_signup])
    if @signup.save
      redirect_to beta_signup_path
    else
      flash[:errors] = @signup.errors.full_messages
      flash[:params] = params
      redirect_to root_url
    end
  end
end
