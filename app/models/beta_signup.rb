class BetaSignup < ActiveRecord::Base
  validates_format_of :email, :with => /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i
  validates_uniqueness_of :email
end
