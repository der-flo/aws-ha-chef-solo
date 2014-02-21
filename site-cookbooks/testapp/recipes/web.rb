require_recipe 'testapp'

node.set['nginx']['version'] = '1.4.4'
node.set['nginx']['source']['version'] = '1.4.4'
node.set['nginx']['passenger']['version'] = '4.0.37'
node.set['nginx']['passenger']['root'] = "#{node['languages']['ruby']['gems_dir']}/gems/passenger-#{node['nginx']['passenger']['version']}"
node.set['nginx']['source']['url']      = "http://nginx.org/download/nginx-#{node['nginx']['source']['version']}.tar.gz"
node.set['nginx']['source']['checksum'] = '0510af71adac4b90484ac8caf3b8bd519a0f7126250c2799554d7a751a2db388'


node.set['nginx']['init_style'] = 'upstart'

node.set['nginx']['source']['modules']  = %w[
                                           nginx::http_ssl_module
                                           nginx::http_gzip_static_module
                                           nginx::passenger
                                         ]


include_recipe 'nginx::source'
#include_recipe 'nginx::passenger'

cookbook_file "#{node['nginx']['dir']}/sites-available/testapp"
nginx_site 'default' do
  enable false
end
nginx_site 'testapp'
