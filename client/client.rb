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
      self.id = CGI.escape(username).gsub('.','%2e')
      hash = {:session=>{
        :hmac=>hmac(@session.session_secret, "POST /user/#{self.username} #{@session.sid}"),
        :sid=>@session.sid
      }}
      returning connection.post(element_path, hash.to_xml, self.class.headers) do |response|
        load_attributes_from_response(response)
        self.id = self.username
      end
    end
    
    def destroy
      hash = {:session=>{
        :hmac=>hmac(@session.session_secret, "DELETE /user/#{self.username} #{@session.sid}"),
        :sid=>@session.sid
      }}
      connection.delete(element_path(hash), self.class.headers)
      self.freeze
    end
    
    def find_by_username(username)
      self.id = CGI.escape(username).gsub('.','%2e')
      path = element_path(:session=>{
        :hmac=>hmac(@session.session_secret, "GET /user/#{username} #{@session.sid}"),
        :sid=>@session.sid
      })
      load connection.get(path)
      self.id = CGI.escape(self.username).gsub('.','%2e')
      return self
    rescue ActiveResource::ForbiddenAccess
      return nil
    end
    
    def set_password(new_password)
      hmac = hmac(@session.session_secret, "PUT /user/#{self.username} #{@session.sid} #{new_password}")
      fields = {:password=>new_password, :session=>{:hmac=>hmac, :sid=>@session.sid}}.to_xml
      returning connection.put(element_path(prefix_options), fields, self.class.headers) do |response|
        load_attributes_from_response(response)
      end
    end
    
    def to_legacy_object
      return LegacyUser.new do |u|
        # different names
        u.admin = self.legacy_admin
        u.email = self.username
        # same names
        %w{company_id token first_name last_name created_at updated_at}.each{|f| u.send("#{f}=", self.send(f))}
      end
    end
  end
  
  class LegacyUser
    %w{company_id email password token first_name last_name permission admin created_at updated_at}.each{|a|attr_accessor a.to_sym}
    
    def initialize
      yield self
    end
    
    def to_legacy_session
      session = {}
      session[:token] = self.token
      session[:user] = self
      session[:company_id] = self.company_id
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
    rescue ActiveResource::ForbiddenAccess
      raise ShoveAuth::Error, "forbidden"
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

