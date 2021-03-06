require_recipe 'testapp'

node.set['nginx']['version'] = '1.4.4'
node.set['nginx']['source']['version'] = '1.4.4'
node.set['nginx']['source']['prefix']                  = "/opt/nginx-#{node['nginx']['source']['version']}"
node.set['nginx']['source']['conf_path']               = "#{node['nginx']['dir']}/nginx.conf"
node.set['nginx']['source']['sbin_path']               = "#{node['nginx']['source']['prefix']}/sbin/nginx"
node.set['nginx']['source']['default_configure_flags'] = %W[
                                                          --prefix=#{node['nginx']['source']['prefix']}
                                                          --conf-path=#{node['nginx']['dir']}/nginx.conf
                                                          --sbin-path=#{node['nginx']['source']['sbin_path']}
                                                        ]
node.set['nginx']['source']['url']      = "http://nginx.org/download/nginx-#{node['nginx']['source']['version']}.tar.gz"
node.set['nginx']['source']['checksum'] = '0510af71adac4b90484ac8caf3b8bd519a0f7126250c2799554d7a751a2db388'

node.set['nginx']['passenger']['version'] = '4.0.38'
node.set['nginx']['passenger']['root'] = "#{node['languages']['ruby']['gems_dir']}/gems/passenger-#{node['nginx']['passenger']['version']}"



node.set['nginx']['init_style'] = 'upstart'

node.set['nginx']['source']['modules']  = %w[
                                           nginx::http_ssl_module
                                           nginx::http_gzip_static_module
                                           nginx::passenger
                                         ]


include_recipe 'nginx::source'

# TODO: node[:roles].include? 'web'

cookbook_file "#{node['nginx']['dir']}/sites-available/testapp"
nginx_site 'default' do
  enable false
end
nginx_site 'testapp'
