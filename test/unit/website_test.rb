require 'test_helper'

class WebsiteTest < ActiveSupport::TestCase
  test "new_from_path" do
    path    = Path.new_from_info(DropboxData.ls_only_dirs.first)
    website = Website.new_from_path(path)

    assert_equal path,                   website.path
    assert_equal path.user,              website.user
    assert_equal path.path.sub("/", ""), website.subdomain
    assert       website.active?
  end

  test "cannot be active if subdomain is not valid" do
    website = Website.new
    website.subdomain = "billy_bob"

    assert !website.can_be_active?
  end

  test "cannot be active if subdomain is taken" do
    website = Website.new
    website.subdomain = "billy-bob"

    Website.expects(:find_by_subdomain).with("billy-bob").returns(Website.new)
    assert !website.can_be_active?

    Website.expects(:find_by_subdomain).with("billy-bob").returns(website)
    assert website.can_be_active?
  end

  test "activate turns on the site" do
    website = Website.new
    website.expects(:can_be_active?).returns true
    assert website.activate!
    assert website.active?
  end

  test "activate does not turn on the site when unable" do
    website = Website.new
    website.expects(:can_be_active?).returns false
    assert !website.activate!
    assert !website.active?
  end
end
