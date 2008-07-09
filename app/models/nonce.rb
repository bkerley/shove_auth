class Nonce < ActiveRecord::Base
  before_create :creation_generator
  belongs_to :account, :foreign_key => :user_id
  
  # create-time methods
  
  def creation_generator
    self.nonce = Base64.encode64(OpenSSL::Random.random_bytes(30)).chomp
    self.sid = Base64.encode64(OpenSSL::Random.random_bytes(30)).chomp
  end
  
  def load_user(user, hmac)
    check = Nonce.hmac(user.digest, "PUT /session/#{sid} #{nonce}")
    return false unless check == hmac
    self.user_id = user.id
    return user
  end
  
  # inspector methods
  
  def state
    return self.user_id ? :authenticated : :not_authenticated
  end
  
  # serialization methods
  
  def to_xml
    super(serialization_options)
  end
  
  def to_json
    super(serialization_options)
  end
  
  def serialization_options
    {:methods=>[:state], :except=>[:id, :user_id]}
  end
  
  # class methods
  
  def self.load_user(sid, username, hmac)
    user = Account.find_by_username(username)
    return false unless user
    nonce = find_by_sid(sid)
    return false unless nonce
    r = nonce.load_user(user, hmac)
    return false unless r
    nonce.save
    return user
  end
  
  def self.hmac(secret, message)
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('SHA1'), secret, message)
  end
end
