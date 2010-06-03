class Path < ActiveRecord::Base
  belongs_to :parent, :class_name => "Path"
  belongs_to :user
  belongs_to :website
  has_one    :owned_website, :class_name => "Website", :dependent => :destroy

  def self.new_from_info(*args)
    ret = new
    ret.take_attributes_from_info(*args)
    ret
  end

  def take_attributes_from_info(info, attributes={})
    self.attributes = attributes
    self.path       = info.path
    self.last_hash  = info.hash
    self.directory  = info.directory?
  end

  def create_website
    return if owned_website
    self.owned_website = self.website = Website.new_from_path(self)
    owned_website.paths << self
    user.websites << owned_website
    owned_website
  end
end
