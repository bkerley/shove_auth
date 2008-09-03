namespace :cas do
	desc 'Pull legacy data from CAS'
	task :migrate => :environment do
		users = Hash.from_xml(File.read('cas-users.xml'))['users']['row']
		users.each do |u|
			account = Account.find_by_username(u['email'])
			if account.nil?
				puts "On the floor: #{u['email']} (id #{u['id']})"
				next
			end
			
			account.legacy_admin = u.admin
			%w{company_id token first_name last_name created_at updated_at}.each{|f| account.send("#{f}=", u.send(f))}
		end
	end
end