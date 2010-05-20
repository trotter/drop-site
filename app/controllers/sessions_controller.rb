class SessionsController < ApplicationController
  def create
    dropbox_session = Dropbox::Session.new('iepvouixlhuo6dg', 'fhs5rghf6tz7ia9')
    session[:dropbox_session] = dropbox_session.serialize
    redirect_to dropbox_session.authorize_url(:oauth_callback => finalize_session_url)
  end

  def finalize
    dropbox_session = Dropbox::Session.deserialize(session[:dropbox_session])
    dropbox_session.authorize(params)
    session[:dropbox_session] = dropbox_session.serialize # re-serialize the authenticated session

    redirect_to websites_url
  end
end
