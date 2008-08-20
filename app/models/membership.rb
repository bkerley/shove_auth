class Membership < ActiveRecord::Base
  belongs_to :account
  
  def inspect
    "%#{group}"
  end
end
