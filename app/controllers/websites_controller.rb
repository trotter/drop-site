class WebsitesController < ApplicationController
  def index
    dropbox_session = Dropbox::Session.deserialize(session[:dropbox_session])
    @user = User.find_or_create_from_session(dropbox_session)
  end
end
