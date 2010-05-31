require 'test_helper'

class SiteBuilderTest < ActiveSupport::TestCase
  setup do
    @user = User.new(:session => "blah")
    @site_builder = SiteBuilder.new(@user)
  end
end
