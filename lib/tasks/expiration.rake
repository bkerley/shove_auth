namespace :nonce do
  desc 'Clear out any old nonces/sessions'
  task :expire => :environment do
    Nonce.find_outdated.map(&:destroy)
  end
end