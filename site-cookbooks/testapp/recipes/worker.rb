require_recipe 'testapp'

cookbook_file '/etc/init/sidekiq.conf'
service 'sidekiq' do
  provider Chef::Provider::Service::Upstart
  supports status: false

  if node[:ec2][:roles].include? 'worker'
    action [:enable, :start]
  else
    action [:disable, :stop]
  end
end
