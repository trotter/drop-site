class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'

  def login_required
    unless current_user
      flash[:error] = "You must login."
      redirect_to root_url
    end
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end
  helper_method :current_user

  def current_user=(user)
    session[:user_id] = user.id
    @current_user = user
  end
end
