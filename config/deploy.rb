set :application, 'stubbly'
set :repository, 'git@github.com:jparker/stubbly.git'

set :user, 'appserve'
set :use_sudo, false
set :deploy_to, '/var/www/stubbly'

set :scm, :git
set :branch, 'master'
set :deploy_via, :remote_cache

role :app, 'moa.urgetopunt.com'
role :web, 'moa.urgetopunt.com'
role :db, 'moa.urgetopunt.com'

namespace :deploy do
  desc 'Restart application server'
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end
