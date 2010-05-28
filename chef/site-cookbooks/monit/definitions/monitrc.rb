define :monitrc do
  template "/etc/monit/conf.d/#{params[:name]}.monitrc" do
    owner "root"
    group "root"
    mode 0644
    source params[:source]
    variables params[:variables]
    notifies :restart, resources(:service => "monit")
    action :create
  end
end
