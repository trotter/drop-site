class SiteFinder
  def initialize(user)
    @user = user
    @updated_websites = []
    @updated_paths = []
  end

  def update
    find_websites
    save_paths
    update_websites
  end

  def find_websites
    get_or_create_root(session.info("/"))
  end

  def save_paths
    @updated_paths.each do |path|
      path.save
    end
  end

  def update_websites
    @updated_websites.each do |site|
      site.save
      SiteBuilder.new(@user, session, site).update
    end
  end

  def get_or_create_root(info)
    with_path_for(info) do |path|
      session.ls(path.path).each do |info|
        update_website(info, path) if info.directory?
      end
    end
  end

  def update_website(info, root)
    with_path_for(info) do |path|
      path.parent = root
      path.create_website
      @updated_websites << path.website
    end
  end

  def with_path_for(info)
    path = @user.paths.find_by_path(info.path)
    path ||= @user.paths.build(:user => @user)
    if path.last_hash != info.hash
      @updated_paths << path
      path.take_attributes_from_info(info)
      yield path
    end
  end

  def session
    @session ||= Dropbox::Session.deserialize(@user.session)
  end
end
