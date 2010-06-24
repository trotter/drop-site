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
    @mock_session.stubs(:info).with("/some.txt").returns DropboxData.file_info
    @mock_session.stubs(:info).with("/cool-site").returns DropboxData.dir_info
    @mock_session.stubs(:account).returns({:display_name => "Trotter Cashion"}.to_struct)
    @mock_session.stubs(:authorize)
    @mock_session.stubs(:serialize).returns("serialized_session")
    @mock_session.stubs(:authorize_url).returns("http://fake.dropbox/authorize")
    Dropbox::Session.stubs(:new).returns(@mock_session)
    Dropbox::Session.stubs(:deserialize).returns(@mock_session)
  end

  def login(user=nil)
    id = 12345
    @current_user = user || User.new do |u|
      u.id = id
    end
    User.stubs(:find_by_id).with(id).returns @current_user
    session[:user_id] = id
  end
end
