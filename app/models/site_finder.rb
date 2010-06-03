class SiteFinder
  def initialize(user)
    @user = user
    @updated_websites = []
    @updated_paths = []
  end

  def update
    find_websites
    update_websites
    save_paths
  end

  def root_path
    @user.paths.find_by_path("") ||
      @user.paths.build(:user => @user, :path => "")
  end

  def find_websites
    get_or_create_root(root_path)
  end

  def save_paths
    @updated_paths.each do |path|
      path.save
    end
  end

  def update_websites
    @updated_websites.each do |site|
      Rails.logger.info "[SiteFinder#update_websites] Updating #{site.subdomain}"
      site.save
      SiteBuilder.new(@user, session, site).update
    end
  end

  def get_or_create_root(path)
    find_updates_for(path) do |raw_data|
      raw_data.contents.each do |info|
        next unless info.directory?
        subpath = @user.paths.find_by_path(info.path)
        subpath ||= @user.paths.build(:user => @user, :path => info.path)
        update_website(subpath, path)
      end
    end
  end

  def update_website(path, root)
    find_updates_for(path) do |raw_data|
      path.parent = root
      path.create_website
      @updated_websites << path.website
    end
  end

  def find_updates_for(path)
    info = session.info(path.path)
    if path.last_hash != info.hash
      @updated_paths << path
      path.take_attributes_from_info(info)
      yield info
    end
  end

  def session
    @session ||= Dropbox::Session.deserialize(@user.session)
  end
end
