class User < ActiveRecord::Base
  has_many :paths
  has_many :websites

  def self.find_or_create_from_session(dropbox_session)
    name = dropbox_session.account.display_name
    unless ret = User.find_by_name(name)
      ret = User.new
      ret.name = name
      ret.subdomain = name.downcase.gsub(/[^A-Za-z0-9]+/, "-")
    end
    ret.session = dropbox_session.serialize
    ret.save
    ret
  end
end
