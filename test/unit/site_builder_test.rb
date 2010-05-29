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
    assert @user.paths.detect { |p| p.path == "/" }
  end

  test "should create subpaths if they exist" do
    @mock_session.expects(:info).with("/").returns DropboxData.root_info
    @mock_session.expects(:ls).with("/").returns DropboxData.ls_no_dirs
    @site_builder.update
    assert_equal 2, @user.paths.size
    assert @user.paths.detect { |p| p.path == DropboxData.ls_no_dirs.first.path }
  end
end
