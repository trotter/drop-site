class WebsitesController < ApplicationController
  def index
    dropbox_session = Dropbox::Session.deserialize(session[:dropbox_session])
    @directories = dropbox_session.ls('/')
  end
end
