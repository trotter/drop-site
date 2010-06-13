class BetaSignupsController < ApplicationController
  def create
    @signup = BetaSignup.new(params[:beta_signup])
    if @signup.save
      flash[:success] = "Thank you. We will email you when we have space available."
    else
      flash[:errors] = @signup.errors.full_messages
      flash[:params] = params
    end
    redirect_to root_url
  end
end
