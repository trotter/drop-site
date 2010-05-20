class DropboxPingbacksController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def uninstall
    logger.info params.inspect
    head :status => 200
  end

  def file
    logger.info params.inspect
    head :status => 200
  end
end
