#
# Cookbook Name:: dropsite
# Recipe:: default
#
# Copyright 2010, Trotter Cashion
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "monit"
include_recipe "git"
include_recipe "apache2::mod_expires"
include_recipe "passenger_apache2::mod_rails"

package "coreutils" # Includes nohup, needed for our monit template
package "libxml2"       # For nokogiri
package "libxml2-dev"   # For nokogiri
package "libxslt1.1"       # For nokogiri
package "libxslt1-dev"   # For nokogiri

gem_package "bundler" do
  version "0.9.26"
end

gem_package "rvm"

deploy_dir = node[:dropsite_rails][:deploy_dir]
app_dir    = node[:dropsite_rails][:app_dir] || "#{node[:dropsite_rails][:deploy_dir]}/current"
path_to_key = "#{ENV['HOME']}/.ssh/dropsite_deploy"
ssh_wrapper_path = "#{deploy_dir}/git-wrapper.sh"

# create the app directory
directory deploy_dir do
  owner node[:main_user]
  group node[:main_group]
end

template ssh_wrapper_path do
  owner node[:main_user]
  group node[:main_group]
  source "git-wrapper.sh.erb"
  mode "755"
  variables :path_to_key => path_to_key
end

# Tell apache about our app
web_app :dropsite_rails do
  cookbook       "passenger_apache2"
  docroot        "#{app_dir}/public"
  server_name    node[:dropsite_rails][:hostname]
  server_aliases []
  rails_env      node[:dropsite_rails][:framework_env]
end

# Create the logs and pids dirs
%w(log pids).each do |shared_dir|
  directory "#{deploy_dir}/shared/#{shared_dir}" do
    owner node[:main_user]
    group node[:main_group]
    recursive true
  end
end

deploy deploy_dir do
  repo              node[:dropsite_rails][:repo]
  revision          node[:dropsite_rails][:revision]
  user              node[:main_user]
  group             node[:main_group]
  migrate           node[:dropsite_rails][:run_migrations]
  migration_command "rake db:migrate"
  environment       "RAILS_ENV" => node[:dropsite_rails][:framework_env]
  ssh_wrapper       ssh_wrapper_path
  shallow_clone     true
  restart_command   "touch tmp/restart.txt"
  # override the default linking of database.yml to shared config folder
  symlink_before_migrate({})

  # Before migrating, we want to run bundler and create the db
  before_migrate do
    system %Q{cd #{release_path}; bundle install --without=test}
    system %Q{su -l #{node[:main_user]} -m -c "cd #{release_path}; rake db:create:all"}
  end

  action :deploy
  only_if { node[:dropsite_rails][:run_deploy] }
  notifies :reload, resources(:service => "monit")
end

template "#{deploy_dir}/shared/dropbox_syncer_control" do
  source "dropbox_syncer_control.erb"
  owner  node[:main_user]
  group  node[:main_group]
  mode   "755"
  variables :app_dir => app_dir
end

monitrc "dropbox_syncer" do
  source "dropbox_syncer.monitrc.erb"
  variables :environment => node[:dropsite_rails][:framework_env],
            :deploy_dir => deploy_dir,
            :worker_name => "all"
end

# Setup logrotate to rotate the logs
template "/etc/logrotate.d/rails_app" do
  source "logrotate.erb"
  variables :log_path => "#{app_dir}/log/*.log"
  backup false
end

