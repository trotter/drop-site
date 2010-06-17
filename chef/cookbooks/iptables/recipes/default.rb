#
# Cookbook Name:: iptables
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

package "iptables" do
  case node[:platform]
  when "debian","ubuntu"
    package_name "iptables"
  end
  action :install
end

template "/etc/iptables.test.rules" do
  source "iptables.test.rules.erb"
  variables :tcp_ports => node[:iptables][:tcp_ports],
            :ssh_port  => node[:ssh][:port]
  action :create
end

execute "set-iptables" do
  command "iptables-restore < /etc/iptables.test.rules; iptables-save > /etc/iptables.up.rules"
  action :run
end

bash "load-iptables-on-boot" do
  not_if "grep -q 'pre-up iptables-restore < /etc/iptables.up.rules' /etc/network/interfaces"
  code <<-EOS
  sed -e 's/^iface lo inet loopback$/&\\\npre-up iptables-restore < \\/etc\\/iptables.up.rules/' /etc/network/interfaces > /tmp/interfaces.tmp
  mv /tmp/interfaces.tmp /etc/network/interfaces
  EOS

  action :run
end
