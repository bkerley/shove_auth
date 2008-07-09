class Account < ActiveRecord::Base
  
  def password=(password)
    self.digest = Account.digest(self.username, password)
  end
  
  def check_digest(password)
    return self.digest == Account.digest(self.username, password)
  end
  
  def self.digest(username, password)
    sha1 = OpenSSL::Digest::Digest.new('SHA1')
    sha1 << username << new_pass
    return Base64.encode64(sha1.digest).chomp
  end
end
