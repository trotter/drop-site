require 'test_helper'

class PathTest < ActiveSupport::TestCase
  setup do
    @user = User.new
    @info = DropboxData.root_info
    @path = Path.new_from_info(@info)
    @path.user = @user
  end

  test "new_from_info should use dropbox info to make a new path" do
    assert_equal @path.path,       @info.path
    assert_equal @path.last_hash,  @info.hash
    assert_equal @path.directory?, @info.directory?
  end

  test "new_from_info should take an optional parent" do
    parent = Path.new
    path = Path.new_from_info(@info, :parent => parent)
    assert_equal parent, path.parent
  end

  test "should create_website" do
    website = @path.create_website
    assert_equal website, @path.owned_website
    # TODO: Fix this broken test
#    assert_equal website, @path.website
    assert website.paths.include?(@path)
    assert @user.websites.include?(website)
  end
end
