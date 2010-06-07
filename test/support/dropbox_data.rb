# NOTE: We're using #to_struct from rdropbox. It's nodoc'd, so we'll
# need to change if that ever changes.
module DropboxData
  def self.root_info
    { :hash => "abcdefg",
      :path => "",
      :directory? => true,
      :contents => []}.to_struct
  end

  def self.root_info_no_dirs
    { :hash => "abcdefg",
      :path => "",
      :directory? => true,
      :contents => ls_no_dirs}.to_struct
  end

  def self.root_info_only_dirs
    { :hash => "abcdefg",
      :path => "",
      :directory? => true,
      :contents => ls_only_dirs}.to_struct
  end

  def self.file_info
    {:path => "/some.txt", :hash => "bcdefgh", :directory? => false}.to_struct
  end

  def self.ls_no_dirs
    [{:path => "/some.txt", :directory? => false}.to_struct]
  end

  def self.dir_info
    {:path => "/cool-site", :hash => "cdefghi", :directory? => true,
     :contents => [{:path => "/cool-site/blah.txt", :directory? => false}.to_struct]
    }.to_struct
  end

  def self.ls_only_dirs
    [{:path => "/cool-site", :directory? => true}.to_struct]
  end
end
