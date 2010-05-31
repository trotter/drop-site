class Path < ActiveRecord::Base
  belongs_to :parent, :class_name => "Path"
  belongs_to :user
  has_one    :website, :dependent => :destroy

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
    return if website
    self.website = Website.new_from_path(self)
    user.websites << self.website
    website
  end
end
