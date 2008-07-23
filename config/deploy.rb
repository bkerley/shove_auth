set :application, "shove_auth"
set :repository,  "git@github.com:bkerley/shove_auth.git"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/home/shove/apps/#{application}"
set :user, 'shove'
set :run_method, :run
set :deploy_via, :remote_cache
set :git_enable_submodules, 1


# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git

role :app, "tech.worldmedia.net"
role :web, "tech.worldmedia.net"
role :db,  "tech.worldmedia.net", :primary => true

deploy.task :start do
  accelerator.smf_start
end

deploy.task :stop do
  accelerator.smf_stop
end

deploy.task :restart do
  accelerator.smf_restart
end
