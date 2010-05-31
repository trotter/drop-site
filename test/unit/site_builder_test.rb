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

    root_path = @user.paths.detect { |p| p.path == "/" }
    assert root_path
    assert_equal @user, root_path.user
  end

  test "should create subpaths if they exist" do
    @mock_session.expects(:info).with("/").returns DropboxData.root_info
    @mock_session.expects(:ls).with("/").returns DropboxData.ls_no_dirs
    @site_builder.update
    assert_equal 2, @user.paths.size
    assert @user.paths.detect { |p| p.path == DropboxData.ls_no_dirs.first.path }
  end

  test "should create website for directories directly below root" do
    contents = DropboxData.ls_only_dirs
    @mock_session.expects(:info).with("/").returns DropboxData.root_info
    @mock_session.expects(:ls).with("/").returns contents
    @mock_session.expects(:ls).with(contents.first.path).returns DropboxData.ls_no_dirs
    @site_builder.update
    assert_equal 3, @user.paths.size

    website_path = @user.paths.detect { |p| p.path == contents.first.path }
    assert website_path
    assert_equal 1, @user.websites.size
    assert_equal website_path, @user.websites.first.path
  end

  test "should not bother with subpaths if root hash matches" do
    @user.paths.expects(:find_by_path).with("/").
      returns Path.new_from_info(DropboxData.root_info)
    @mock_session.expects(:info).with("/").returns DropboxData.root_info
    @mock_session.expects(:ls).never
    @site_builder.update
  end

  test "should bother with subpaths if root hash does not match" do
    info = DropboxData.root_info
    info.hash = "DIFFERENT"
    root_path = Path.new_from_info(info)
    root_path.user = @user
    @user.paths.stubs(:find_by_path).returns nil
    @user.paths.expects(:find_by_path).with("/").returns root_path
    @mock_session.expects(:info).with("/").returns DropboxData.root_info
    @mock_session.expects(:ls).with("/").returns DropboxData.ls_no_dirs
    @site_builder.update

    # We already created the root, so we're only making the new one
    assert_equal 1, @user.paths.size
  end
end
