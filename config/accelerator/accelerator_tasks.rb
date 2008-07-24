require 'erb'
Capistrano::Configuration.instance(:must_exist).load do
  namespace :accelerator do
    
    desc "Adds a SMF for the application"
    task :create_smf, :roles => :app do
      puts "set variables"
      service_name = application
      working_directory = current_path
      
      template = File.read("config/accelerator/smf_template.erb")
      buffer = ERB.new(template).result(binding)
      
      put buffer, "#{shared_path}/#{application}-smf.xml"
      
      run "svccfg import #{shared_path}/#{application}-smf.xml"
    end
  
    
    desc "Restart nginx"
    task :restart_nginx, :roles => :web do
      run "svcadm restart svc:/network/nginx-static-assets:default"
      # If you're on a new pkgsrc templated accelerator replace the line above with the following line:
      # sudo "svcadm restart apache"
    end
    
    desc "Stops the application"
    task :smf_stop, :roles => :app do
      run "svcadm disable /network/mongrel/#{application}-production"
    end
  
    desc "Starts the application"
    task :smf_start, :roles => :app do
      run "svcadm enable -r /network/mongrel/#{application}-production"
    end
  
    desc "Restarts the application"
    task :smf_restart do
      run "svcadm restart /network/mongrel/#{application}-production"
    end
 
    desc "Deletes the configuration"
    task :smf_delete, :roles => :app do
      run "svccfg delete /network/mongrel/#{application}-production"
    end
 
    desc "Shows all Services"
    task :svcs, :roles => :app do
      run "svcs -a" do |ch, st, data|
        puts data
      end
    end
    
    
  end
  
  after 'deploy:setup', 'accelerator:create_smf'
  
end
