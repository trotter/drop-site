require 'test_helper'

class SiteBuilderTest < ActiveSupport::TestCase
  setup do
    @user = User.new(:session => "blah")
    @path = Path.new_from_info(DropboxData.root_info, :user => @user)
    @website = Website.new(:user => @user, :subdomain => "bob", :path => @path)
    @site_builder = SiteBuilder.new(@user, @mock_session, @website)
  end

  test "should create paths for contents of website" do
    contents = DropboxData.ls_no_dirs
    @mock_session.expects(:ls).with(@path.path).returns contents
    @site_builder.update

    new_path = @user.paths.detect { |p| p.path == contents.first.path }
    assert new_path
    assert_equal @path, new_path.parent
  end

  test "should save paths" do
    Path.any_instance.expects(:save)
    @mock_session.expects(:ls).with(@path.path).returns DropboxData.ls_no_dirs
    @site_builder.update
  end
end
