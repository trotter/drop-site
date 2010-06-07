class Website < ActiveRecord::Base
  belongs_to :user
  belongs_to :root_path, :class_name => "Path"
  has_many   :paths, :dependent => :destroy

  def self.new_from_path(path)
    ret = new
    ret.root_path = path
    ret.user      = path.user
    ret.subdomain = path.path[1..-1]
    ret.active    = ret.can_be_active?
    ret
  end

  def activate!
    self.active = can_be_active?
  end

  def can_be_active?
    !!valid_subdomain? &&
      subdomain_available?
  end

  def valid_subdomain?
    subdomain =~ /^[A-Za-z0-9-]+$/
  end

  def subdomain_available?
    existing = self.class.find_by_subdomain(subdomain)
    !existing || existing == self
  end
end
