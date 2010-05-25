require 'fileutils'

class SiteBuilder
  def self.run(user)
    new(user).run
  end

  def initialize(user)
    @user = user
    @files_to_update = []
  end

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
      filename = dir.join(on_dropbox.path[1..-1])
      dirname  = File.dirname(filename)
      FileUtils.mkdir_p(dirname) unless File.exist?(dirname)
      File.open(filename, "w") do |on_filesystem|
        on_filesystem.write(@session.download(on_dropbox.path))
      end
    end
  end
end
