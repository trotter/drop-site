#
# Cookbook Name:: dropsite_sites
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

sites_dir = "/srv/dropsite_sites/public"

directory sites_dir do
  action    :create
  owner     node[:main_user]
  group     node[:main_group]
  recursive true
end

web_app :dropsite_sites do
  docroot        "/srv/dropsite_sites/public"
  server_name    node[:dropsite_sites][:hostname]
  server_aliases "*.#{node[:dropsite_sites][:hostname]}"
end
