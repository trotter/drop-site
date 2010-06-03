ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'ruby-debug'
require 'rails/test_help'
require 'support/dropbox_data'
require 'mocha'

class ActiveSupport::TestCase
  # Gonna try not using fixtures
  # fixtures :all
  
  # The global setup
  setup do
    stub_dropbox
  end

  def stub_dropbox
    @mock_session = mock("session")
    @mock_session.stubs(:ls).returns []
    @mock_session.stubs(:account).returns({:display_name => "Trotter Cashion"}.to_struct)
    @mock_session.stubs(:authorize)
    @mock_session.stubs(:serialize).returns("serialized_session")
    Dropbox::Session.stubs(:deserialize).returns(@mock_session)
  end
end
