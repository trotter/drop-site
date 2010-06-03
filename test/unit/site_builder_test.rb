require 'test_helper'

class SiteBuilderTest < ActiveSupport::TestCase
  setup do
    @user = User.new(:session => "blah")
    @path = Path.new_from_info(DropboxData.root_info, :user => @user)
    @website = Website.new(:user => @user, :subdomain => "bob", :path => @path)
    @site_builder = SiteBuilder.new(@user, @mock_session, @website)
  end

  test "should create paths for contents of website" do
    @site_builder.stubs(:update_filesystem)
    contents = DropboxData.ls_no_dirs
    @mock_session.expects(:ls).with(@path.path).returns contents
    @site_builder.update

    new_path = @user.paths.detect { |p| p.path == contents.first.path }
    debugger; 1
    assert new_path
    assert_equal @path, new_path.parent
  end

  test "should save paths" do
    @site_builder.stubs(:update_filesystem)
    Path.any_instance.expects(:save)
    @mock_session.expects(:ls).with(@path.path).returns DropboxData.ls_no_dirs
    @site_builder.update
  end

  test "should update the filesystem" do
    contents = DropboxData.ls_no_dirs
    @mock_session.expects(:ls).with(@path.path).returns contents

    dirname = SiteBuilder.root
    File.expects(:exist?).with(dirname).returns false
    FileUtils.expects(:mkdir_p).with(dirname)

    mock_filesystem = mock('filesystem')
    mock_filesystem.expects(:write)
    File.expects(:open).with(dirname + contents.first.path, "w").yields mock_filesystem

    @mock_session.expects(:download).with(contents.first.path)

    @site_builder.update
  end

  test "should remove paths that were deleted on dropbox" do
    pending
  end
end
