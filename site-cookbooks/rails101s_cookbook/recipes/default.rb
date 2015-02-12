template 'nginx.conf' do
  path   "#{node['nginx']['dir']}/nginx.conf"
  source "nginx/nginx.conf.erb"
  owner "root"
  group node['root_group']
  mode 0644
end

projects = node[:projects]
projects.each do |project|
  template "#{node['nginx']['dir']}/sites-enabled/#{project[:name]}" do
    source "project/#{project[:name]}.#{project[:env]}.erb"
    owner "root"
    group "root"
    mode 0644
    notifies :reload, 'service[nginx]'
  end
end
