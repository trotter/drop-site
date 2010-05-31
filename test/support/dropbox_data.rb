# NOTE: We're using #to_struct from rdropbox. It's nodoc'd, so we'll
# need to change if that ever changes.
module DropboxData
  def self.root_info
    {:hash => "abcdefg", :path => "/", :directory? => true}.to_struct
  end

  def self.ls_no_dirs
    [{:path => "/some.txt", :hash => "bcdefgh", :directory? => false}.to_struct]
  end

  def self.ls_only_dirs
    [{:path => "/cool-site", :hash => "cdefghi", :directory? => true}.to_struct]
  end
end
