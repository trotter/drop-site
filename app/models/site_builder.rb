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
    update_tree
    update_filesystem
  end

  def update_tree
    get_or_create_from_info(session.info("/"), :is_root => true)
  end

  def get_or_create_subpaths(path, opts={})
    session.ls(path.path).each do |info|
      get_or_create_from_info(info, opts)
    end
  end

  def get_or_create_from_info(info, opts={})
    path = @user.paths.find_by_path(info.path)
    path ||= @user.paths.build(:user => @user)
    if path.last_hash != info.hash
      path.take_attributes_from_info(info)
      @updated_paths << path
      if path.directory?
        path.create_website if opts[:create_websites]

        new_opts = {}
        new_opts[:create_websites] = opts[:is_root]
        get_or_create_subpaths(path, new_opts)
      end
    end
  end

  def session
    @session ||= Dropbox::Session.deserialize(@user.session)
  end

  def update_filesystem
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
