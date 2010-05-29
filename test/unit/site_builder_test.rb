require 'test_helper'

class SiteBuilderTest < ActiveSupport::TestCase
  setup do
    @user = User.new(:session => "blah")
    @site_builder = SiteBuilder.new(@user)
  end

  test "should create the root path if it does not exist" do
    @mock_session.expects(:info).with("/").returns DropboxData.root_info
    @site_builder.update
    assert_equal 1, @user.paths.size
    assert_equal "/", @user.paths.first.path
    assert_equal DropboxData.root_info.hash, @user.paths.first.last_hash
  end
end
