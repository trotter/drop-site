class BetaSignup < ActiveRecord::Base
  validates_presence_of :email
  validates_format_of :email, :with => /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i
end
