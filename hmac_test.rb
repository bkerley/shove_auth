require 'openssl'
d = OpenSSL::Digest::Digest.new('SHA1')
k = (0x30..0x43).to_a
t = "Sample #2"
puts OpenSSL::HMAC.hexdigest(d, k.map{|c|c.chr}.join(''), t) == "0922d3405faa3d194f82a45830737d5cc6c75d24"
