#
# Cookbook Name:: private_ssh_keys
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

node[:ssh][:private_keys].each do |key|
  directory "#{ENV['HOME']}/.ssh" do
    owner node[:main_user]
    group node[:main_group]
    mode "700"
  end

  remote_file "#{ENV['HOME']}/.ssh/#{key}" do
    owner node[:main_user]
    group node[:main_group]
    mode "600"
    source key
  end
end
