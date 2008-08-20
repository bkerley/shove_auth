class Membership < ActiveRecord::Base
  belongs_to :account
  
  def inspect
    "%#{group}"
  end
  
  # return an array already assigned groups
  def self.groups
    connection.select_values("SELECT DISTINCT `group` FROM memberships")
  end
end
