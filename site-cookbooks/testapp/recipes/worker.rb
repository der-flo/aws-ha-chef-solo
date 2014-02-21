require_recipe 'testapp'

cookbook_file '/etc/init/sidekiq.conf'
service 'sidekiq' do
  provider Chef::Provider::Service::Upstart
  supports status: false
  action [:enable, :start]
end
