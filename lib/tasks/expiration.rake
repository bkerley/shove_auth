namespace :nonce do
  desc 'Clear out any old nonces/sessions'
  task :expire => :environment do
    Nonce.find_outdated.each(&:destroy)
  end
end

namespace :test do
  desc 'Wipe out TEMP users from testing'
  task :userclean => :environment do
    Account.all.select {|a| a.username =~ /\d+_TEMP$/}.each &:destroy
  end
end