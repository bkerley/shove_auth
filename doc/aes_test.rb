require 'openssl'
class String
  def to_bin
    [self].pack('H*')
  end
  def to_hex
  unpack('H*').first
  end
end
vectors = [
#cipher:key:iv:plaintext:ciphertext:0/1(decrypt/encrypt)
['603DEB1015CA71BE2B73AEF0857D77811F352C073B6108D72D9810A30914DFF4','000102030405060708090A0B0C0D0E0F','6BC1BEE22E409F96E93D7E117393172A','F58C4C04D6E5F1BA779EABFB5F7BFBD6'],
['603DEB1015CA71BE2B73AEF0857D77811F352C073B6108D72D9810A30914DFF4','F58C4C04D6E5F1BA779EABFB5F7BFBD6','AE2D8A571E03AC9C9EB76FAC45AF8E51','9CFC4E967EDB808D679F777BC6702C7D'],
['603DEB1015CA71BE2B73AEF0857D77811F352C073B6108D72D9810A30914DFF4','9CFC4E967EDB808D679F777BC6702C7D','30C81C46A35CE411E5FBC1191A0A52EF','39F23369A9D9BACFA530E26304231461'],
['603DEB1015CA71BE2B73AEF0857D77811F352C073B6108D72D9810A30914DFF4','39F23369A9D9BACFA530E26304231461','F69F2445DF4F9B17AD2B417BE66C3710','B2EB05E2C39BE9FCDA6C19078C6A9D1B'],
]
vectors.each do |t|
  key = t.shift.to_bin
  iv  = t.shift.to_bin
  pt  = t.shift.to_bin
  res = t.shift.to_bin

  e = OpenSSL::Cipher::Cipher.new('aes-256-cbc')
  d = OpenSSL::Cipher::Cipher.new('aes-256-cbc')
  e.encrypt
  e.key = key
  e.iv = iv
  e.padding = 0
  ct = e.update(pt)
  ct << e.final
  
  puts "Desired:    #{res.to_hex}"
  puts "Ciphertext: #{ct.to_hex}"
  puts "Ciphertext match: #{res.downcase == ct.downcase}"

  d.decrypt
  d.key = key
  d.iv = iv
  d.padding = 0
  final = d.update(ct) + d.final

  puts "Desired:   #{pt.to_hex}"
  puts "Plaintext: #{final.to_hex}"
  puts "Plaintext match: #{pt.downcase == final.downcase}"
end
