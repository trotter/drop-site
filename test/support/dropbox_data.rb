# NOTE: We're using #to_struct from rdropbox. It's nodoc'd, so we'll
# need to change if that ever changes.
module DropboxData
  def self.root_info
    # NOTE: Not certain that path comes down w/ info
    {:hash => "abcdefg", :path => "/", :directory? => true}.to_struct
  end
end
