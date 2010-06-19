class Olympus::OverviewController < ApplicationController
  before_filter :digest_authentication

  def show
  end

  private
    def digest_authentication
      authenticate_or_request_with_http_digest "olympus" do |username|
        "6yhnyuio" if username == "trotter"
      end
    end
end
