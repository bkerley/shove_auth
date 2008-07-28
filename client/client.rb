require 'active_resource'
require 'active_support'
require 'openssl'

module ShoveAuth
  @@site = 'http://localhost:3000/'
  
  # Just log in and discard the session
  def self.login(username, password)
    return Client.new.login(username, password)
  end
  
  def self.site=(newsite)
    @@site = newsite
    Session.site = newsite
    User.site = newsite
  end
  
  def self.site
    return @@site
  end
  
  class Error < RuntimeError; end
  
  class Session < ActiveResource::Base
    include ShoveAuth
    self.site = ShoveAuth.site
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
    self.site = ShoveAuth.site
    self.collection_name = 'user'
    attr_accessor :session
    
    def self.[](session)
      returning User.new do |new_user|
        new_user.session = session
      end
    end
    
    def create
      self.id = username
      hash = {:session=>{
        :hmac=>hmac(@session.session_secret, "POST /user/#{self.username} #{@session.sid}"),
        :sid=>@session.sid
      }}
      returning connection.post(element_path, hash.to_xml, self.class.headers) do |response|
        load_attributes_from_response(response)
        self.id = self.username
      end
    end
    
    def find_by_username(username)
      self.id = username
      path = element_path(:session=>{
        :hmac=>hmac(@session.session_secret, "GET /user/#{username} #{@session.sid}"),
        :sid=>@session.sid
      })
      load connection.get(path)
      self.id = CGI.escape(self.username)
      return self
    rescue ActiveResource::ForbiddenAccess
      return nil
    end
    
    def set_password(new_password)
      hmac = hmac(@session.session_secret, "PUT /user/#{self.username} #{@session.sid} #{new_password}")
      puts hmac
      fields = {:password=>new_password, :session=>{:hmac=>hmac, :sid=>@session.sid}}.to_xml
      returning connection.put(element_path(prefix_options), fields, self.class.headers) do |response|
        load_attributes_from_response(response)
      end
    end
  end
  
  class Client
    attr_reader :username
    
    def initialize
      @session = Session.create
    end
    
    def login(username, password)
      check = @session.authenticate(username, password)
      @username = username if check
      return check
    end
    
    def [](username)
      return User[@session].find_by_username username
    end
    
    def create(username)
      raise ShoveAuth::Error, "user exists" if User[@session].find_by_username username
      returning User[@session] do |new_user|
        new_user.username = username
        new_user.save
      end
    end
    
    def user
      return @user ||= self[@username]
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

