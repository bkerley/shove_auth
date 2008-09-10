class Account < ActiveRecord::Base
  has_many :nonces, :dependent=>:destroy, :foreign_key=>'user_id'
  has_many :memberships, :dependent=>:destroy
  validates_uniqueness_of :username
  
  def password
  end
  
  def password=(password)
    self.digest = Account.digest(self.username, password)
  end
  
  def check_password(password)
    check_digest Account.digest(self.username, password)
  end
  
  def check_digest(digest)
    return self.digest == digest
  end
  
  def acl_groups
    ms_list = self.memberships.map(&:inspect)
    ms_list.unshift self.username
    return ms_list
  end
  
  def self.digest(username, password)
    sha1 = OpenSSL::Digest::Digest.new('SHA1')
    sha1 << username << password
    return Base64.encode64(sha1.digest).chomp
  end
end
