require 'test_helper'

class PathTest < ActiveSupport::TestCase
  test "new_from_info should use dropbox info to make a new path" do
    info = DropboxData.root_info
    path = Path.new_from_info(info)
    assert_equal path.path,       info.path
    assert_equal path.last_hash,  info.hash
    assert_equal path.directory?, info.directory?
  end
end
