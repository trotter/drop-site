require 'fileutils'

class SiteBuilder
  def self.root
    File.join("/srv", "dropsite_sites", "public")
  end

  def self.run(user)
    new(user).run
  end

  def initialize(user, session, website)
    @user    = user
    @session = session
    @website = website
    @updated_paths = []
  end

  def update
    update_tree
    update_filesystem
    save_paths
  end

  def save_paths
    @updated_paths.each do |path|
      path.save
    end
  end

  def update_tree
    get_or_create_subpaths(@website.path)
  end

  def get_or_create_subpaths(path)
    session.ls(path.path).each do |info|
      get_or_create_from_info(info)
    end
  end

  def get_or_create_from_info(info)
    path = @user.paths.find_by_path(info.path)
    path ||= @user.paths.build(:user => @user, :parent => @website.path)
    if path.last_hash != info.hash
      path.take_attributes_from_info(info)
      @updated_paths << path
      if path.directory?
        get_or_create_subpaths(path)
      end
    end
  end

  def session
    @session ||= Dropbox::Session.deserialize(@user.session)
  end

  def root
    self.class.root
  end

  def update_filesystem
    @updated_paths.each do |path|
      next if path.directory?
      filename = root + path.path
      dirname  = File.dirname(filename)
      FileUtils.mkdir_p(dirname) unless File.exist?(dirname)
      File.open(filename, "w") do |on_filesystem|
        on_filesystem.write(@session.download(path.path))
      end
    end
  end
end
