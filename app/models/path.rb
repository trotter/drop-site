class Path < ActiveRecord::Base
  belongs_to :user
  has_one    :website

  def self.new_from_info(info)
    ret = new
    ret.take_attributes_from_info(info)
    ret
  end

  def take_attributes_from_info(info)
    self.path      = info.path
    self.last_hash = info.hash
    self.directory = info.directory?
  end

  def create_website
    return if website
    user.websites << Website.new_from_path(self)
  end
end
