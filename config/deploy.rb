require "bundler/capistrano"

set :application, 'Kobayashi Maru'
set :repository,  'git@github.com:railsrumble/r12-team-124.git'

set :scm, :git

set :deploy_to, '/var/www/apps/railsrumble'
set :user, 'root'


role :web, '74.207.252.245'
role :app, '74.207.252.245'
role :db,  '74.207.252.245', :primary => true

namespace :deploy do
  task :restart, roles: :app do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end



# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
