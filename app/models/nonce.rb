class Nonce < ActiveRecord::Base
  before_create :creation_generator
  
  def creation_generator
    self.nonce = Base64.encode64(OpenSSL::Random.random_bytes(30)).chomp
    self.sid = Base64.encode64(OpenSSL::Random.random_bytes(30)).chomp
  end
end
