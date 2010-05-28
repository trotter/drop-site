#
# Cookbook Name:: monit
# Recipe:: default
#
# Copyright 2010, Example Com
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

# This recipe is *very* Karmic (Ubuntu 9.10) specific
package "monit"

service "monit" do
  supports :restart => true, :reload => true
  reload_command "monit restart all"
  action [:enable, :start]
end

remote_file "/etc/default/monit" do
  source "monit"
  owner "root"
  group "root"

  notifies :restart, resources(:service => "monit")
end

template "/etc/monit/monitrc" do
  source "monitrc.erb"
  owner "root"
  group "root"

  notifies :restart, resources(:service => "monit")
end
