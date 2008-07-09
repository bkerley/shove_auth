require 'openssl'
vectors = [
  {:k=>(0x00..0x3f), :t => 'Sample #1', :c=>'4f4ca3d5d68ba7cc0a1208c9c61e9c5da0403c0a'},
  {:k=>(0x30..0x43), :t => 'Sample #2', :c=>'0922d3405faa3d194f82a45830737d5cc6c75d24'},
  {:k=>(0x50..0xb3), :t => 'Sample #3', :c=>'bcf41eab8bb2d802f3d05caf7cb092ecf8d1a3aa'}
]
vectors.each do |v|
  d = OpenSSL::Digest::Digest.new('SHA1')
  k = v[:k].map{|e|e.chr}.join('')
  t = v[:t]
  c = v[:c]
  puts (OpenSSL::HMAC.hexdigest(d, k, t) == c)
end
