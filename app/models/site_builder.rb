require 'fileutils'

class SiteBuilder
  def self.run(user)
    new(user).run
  end

  def initialize(user)
    @user = user
    @updated_paths = []
#    @files_to_update = []
  end

  def update
    path = get_or_create_path("/")
    save_updated_paths
  end

  def get_or_create_path(path)
    info = session.info("/")
    path = @user.paths.find_by_path("/")
    path ||= @user.paths.build
    if path.last_hash != info.hash
      path.take_attributes_from_info(info)
      @updated_paths << path
      get_or_create_subpaths(path) if path.directory?
    end
    path.hash if path
  end

  def get_or_create_subpaths(path)
    session.ls(path.path).each do |info|
      get_or_create_from_info(info)
    end
  end

  def get_or_create_from_info(info)
    path = @user.paths.find_by_path(info.path)
    path ||= @user.paths.build
    if path.last_hash != info.hash
      path.take_attributes_from_info(info)
      @updated_paths << path
      get_or_create_subpaths(path) if path.directory?
    end
    path.hash if path
  end

  def session
    @session ||= Dropbox::Session.deserialize(@user.session)
  end

  def save_updated_paths
    # do nothing for now
  end

# old code
=begin
  def run
    setup_session
    find_needed_updates
    download_files
  end

  def setup_session
    @session = Dropbox::Session.deserialize(@user.session)
  end

  def find_needed_updates
    hash = @session.info("/").hash
    return if @user.last_hash == hash
    Rails.logger.info "Syncing User{id=#{@user.id};name=#{@user.name};subdomain=#{@user.subdomain}}"
    @user.last_hash = hash
    @user.save

    @files_to_update = @session.ls("/")
    @files_to_update.map! do |f|
      if f.directory?
        @session.ls(f.path)
      else
        f
      end
    end
    @files_to_update.flatten!
  end

  def download_files
    dir = File.join("/srv", "dropsite_sites", "public", @user.subdomain)
    @files_to_update.each do |on_dropbox|
      filename = dir + on_dropbox.path
      dirname  = File.dirname(filename)
      FileUtils.mkdir_p(dirname) unless File.exist?(dirname)
      File.open(filename, "w") do |on_filesystem|
        on_filesystem.write(@session.download(on_dropbox.path))
      end
    end
  end
=end
end
