#
# Cookbook Name:: administrators
# Recipe:: default
#
# Copyright 2009, Trotter Cashion
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

admins = []
node[:users].each_pair do |login, data|
  admins << login if data[:sudo]
  user login do
    gid      "users"
    password data[:password]
    shell    data[:shell] || "/bin/bash"
    home     "/home/#{login}"
    supports :manage_home => true
    action   :create
  end

  directory "/home/#{login}/.ssh" do
    owner  login
    mode   "0700"
    action :create
  end

  file "/home/#{login}/.ssh/authorized_keys" do
    owner  login
    mode   "0600"
    action :create
  end

  execute "add-ssh-key" do
    command %Q|echo "#{data[:ssh_key]}" > /home/#{login}/.ssh/authorized_keys|
  end
end

node[:authorization][:sudo][:users] = admins

include_recipe "sudo"
