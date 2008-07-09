require 'active_resource'

SITE = 'http://localhost:3001/'
class Session < ActiveResource::Base
  self.site = SITE
  self.collection_name = 'session'
end
class User < ActiveResource::Base
  self.site = SITE
  self.collection_name = 'user'
end
