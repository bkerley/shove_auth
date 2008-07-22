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
      
      sudo "svccfg import #{shared_path}/#{application}-smf.xml"
    end
  
    desc "Creates an Apache 2.2 compatible virtual host configuration file"
    task :create_vhost, :roles => :web do
      public_ip = ""
      run "ifconfig -a | ggrep -A1 e1000g0 | grep inet | awk '{print $2}'" do |ch, st, data|
        public_ip = data.gsub(/[\r\n]/, "")
      end
 
      cluster_info = YAML.load(File.read('config/mongrel_cluster.yml'))
 
      start_port = cluster_info['port'].to_i
      end_port = start_port + cluster_info['servers'].to_i - 1
      public_path = "#{current_path}/public"
      
      template = File.read("config/accelerator/apache_vhost.erb")
      buffer = ERB.new(template).result(binding)
      
      put buffer, "#{shared_path}/#{application}-apache-vhost.conf"
 
      sudo "cp #{shared_path}/#{application}-apache-vhost.conf /opt/csw/apache2/etc/virtualhosts/#{application}.conf"
      # If you're on a new pkgsrc templated accelerator replace the line above with the following line:
      # sudo "cp #{shared_path}/#{application}-apache-vhost.conf /opt/local/etc/httpd/virtualhosts/#{application}.conf"
 
      restart_apache
    end
    
    desc "Restart apache"
    task :restart_apache, :roles => :web do
      sudo "svcadm refresh svc:/network/http:cswapache2"
      # If you're on a new pkgsrc templated accelerator replace the line above with the following line:
      # sudo "svcadm restart apache"
    end
    
    desc "Stops the application"
    task :smf_stop, :roles => :app do
      sudo "svcadm disable /network/mongrel/#{application}-production"
    end
  
    desc "Starts the application"
    task :smf_start, :roles => :app do
      sudo "svcadm enable -r /network/mongrel/#{application}-production"
    end
  
    desc "Restarts the application"
    task :smf_restart do
      smf_stop
      smf_start
    end
 
    desc "Deletes the configuration"
    task :smf_delete, :roles => :app do
      sudo "svccfg delete /network/mongrel/#{application}-production"
    end
 
    desc "Shows all Services"
    task :svcs, :roles => :app do
      run "svcs -a" do |ch, st, data|
        puts data
      end
    end
    
    desc "After setup, creates Solaris SMF config file and adds Apache vhost"
    task :setup_smf_and_vhost do
      create_smf
      create_vhost
    end
    
  end
  
  after 'deploy:setup', 'accelerator:setup_smf_and_vhost'
  
end