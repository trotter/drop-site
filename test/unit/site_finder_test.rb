require 'test_helper'

class SitefinderTest < ActiveSupport::TestCase
  setup do
    @user = User.new(:session => "blah")
    @site_finder = SiteFinder.new(@user)
    mock_site_builder = mock('site_builder')
    mock_site_builder.stubs(:update)
    SiteBuilder.stubs(:new).returns mock_site_builder
    Website.any_instance.stubs(:save)
    Path.any_instance.stubs(:save)
  end

  test "should create the root path if it does not exist" do
    @mock_session.expects(:info).with("").returns DropboxData.root_info
    @site_finder.update
    assert_equal 1, @user.paths.size

    root_path = @user.paths.detect { |p| p.path == "" }
    assert root_path
    assert_equal @user, root_path.user
    assert_nil   root_path.parent
  end

  test "should not create paths for anything in root that's not a directory" do
    @mock_session.expects(:info).with("").returns DropboxData.root_info_no_dirs
    @site_finder.update

    assert_equal 1, @user.paths.size
    assert !@user.paths.detect { |p| p.path == DropboxData.root_info_no_dirs.contents.first.path }
  end

  test "should create paths for directories directly below root" do
    contents = DropboxData.root_info_only_dirs.contents
    @mock_session.expects(:info).with("").returns DropboxData.root_info_only_dirs
    @mock_session.expects(:info).with("/cool-site").returns DropboxData.dir_info

    @site_finder.update
    assert_equal 2, @user.paths.size

    root_path    = @user.paths.detect { |p| p.path == "" }
    website_path = @user.paths.detect { |p| p.path == contents.first.path }
    assert_equal root_path, website_path.parent
    assert_equal @user,     website_path.user
  end

  test "should create website for directories directly below root" do
    contents = DropboxData.root_info_only_dirs.contents
    @mock_session.expects(:info).with("").returns DropboxData.root_info_only_dirs
    @mock_session.expects(:info).with("/cool-site").returns DropboxData.dir_info

    @site_finder.update
    website_path = @user.paths.detect { |p| p.path == contents.first.path }
    assert website_path
    assert_equal 1, @user.websites.size
    assert_equal website_path, @user.websites.first.path
  end

  test "should update each website" do
    Website.any_instance.expects(:save)
    mock_site_builder = mock("site_builder")
    mock_site_builder.expects(:update)
    SiteBuilder.expects(:new).with(@user, @mock_session, instance_of(Website)).
      returns mock_site_builder

    @mock_session.expects(:info).with("").returns DropboxData.root_info_only_dirs

    @site_finder.update
  end

  test "should not bother with websites if root hash matches" do
    @user.paths.expects(:find_by_path).with("").
      returns Path.new_from_info(DropboxData.root_info)
    @mock_session.expects(:info).with("").returns DropboxData.root_info_only_dirs
    SiteBuilder.expects(:new).never
    @site_finder.update
  end

  test "should bother with subpaths if root hash does not match" do
    info = DropboxData.root_info_only_dirs
    info.hash = "DIFFERENT"
    root_path = Path.new_from_info(info)
    root_path.user = @user
    @user.paths.stubs(:find_by_path).returns nil
    @user.paths.expects(:find_by_path).with("").returns root_path
    @mock_session.expects(:info).with("").returns DropboxData.root_info_only_dirs
    SiteBuilder.expects(:new).returns mock('site_builder', :update => nil)
    @site_finder.update
  end

  test "should save paths" do
    Path.any_instance.expects(:save)
    @mock_session.expects(:info).with("").returns DropboxData.root_info
    @site_finder.update
  end

  test "should remove paths that were deleted on dropbox" do
    pending
  end
end
