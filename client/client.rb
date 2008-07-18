require 'active_resource'
require 'openssl'

module ShoveAuth
  @@site = 'http://localhost:3001/'
  
  # Just log in and discard the session
  def login(username, password)
    return Client.new.login(username, password)
  end
  
  class Session < ActiveResource::Base
    include ShoveAuth
    self.site = @@site
    self.collection_name = 'session'

    def create
      returning connection.post(collection_path, to_xml, self.class.headers) do |response|
        load_attributes_from_response(response)
        self.id = CGI.escape(self.sid)
      end
    end
    
    def authenticate(username, password)
      self.username = username
      self.hmac = hmac(digest(username, password), "PUT /session/#{self.sid} #{self.nonce}")
      self.save
      return self.state
    rescue ActiveResource::ForbiddenAccess
      return false
    end

  end
  class User < ActiveResource::Base
    include ShoveAuth
    self.site = @@site
    self.collection_name = 'user'
  end
  
  class Client
    def initialize
      @session = Session.create
    end
    
    def login(username, password)
      check = @session.authenticate(username, password)
      @username = username if check
      return check
    end
  end
  
  
  private
  def hmac(secret, message)
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('SHA1'), secret, message)
  end
  
  def digest(username, password)
    sha1 = OpenSSL::Digest::Digest.new('SHA1')
    sha1 << username << password
    return Base64.encode64(sha1.digest).chomp
  end
end

