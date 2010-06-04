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
    return unless @website.active?
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
    @website.paths.directory.each { |path| get_or_create_subpaths(path) }
  end

  def get_or_create_subpaths(path)
    session.ls(path.path.dup).each do |info|
      subpath = @user.paths.find_by_path(info.path)
      subpath ||= @user.paths.build(:path => info.path, :user => @user, :parent => path, :website => @website)
      get_or_create_from_path(subpath, path) unless subpath.directory
    end
  end

  def get_or_create_from_path(path, parent)
    info = session.info(path.path.dup)
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
        on_filesystem.write(@session.download(path.path.dup))
      end
    end
  end
end
