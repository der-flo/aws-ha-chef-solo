#
# Cookbook Name:: testapp
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

timestamped_deploy '/var/www' do
  repo 'https://github.com/der-flo/aws-ha-testapp.git'
  restart_command 'touch tmp/restart.txt'
  symlink_before_migrate.clear
  shallow_clone true
  keep_releases 3
  before_migrate do
    bash 'bundle-install' do
      cwd release_path
      # http://chr4.org/blog/2013/07/31/chef-deploy-revision-and-capistrano-git-style/
      # TODO?
      code 'bundle install'# --deployment'# --path /var/www/shared/bundle'
    end
  end
end

cookbook_file '/etc/init/chef-solo.conf'

################################################################################
# EC2-AMI-Tools
package 'unzip'

zip_path = Chef::Config[:file_cache_path]
zip_file = "#{zip_path}/ec2-ami-tools-1.4.0.9.zip"
remote_file zip_file do
  source 'http://s3.amazonaws.com/ec2-downloads/ec2-ami-tools-1.4.0.9.zip'
  backup false
end

bash 'unarchive_source' do
  cwd  zip_path
  code 'unzip ec2-ami-tools-1.4.0.9.zip -d /usr/local'
  not_if { ::File.directory?('/usr/local/ec2-ami-tools-1.4.0.9') }
end

################################################################################
# Amazon EC2 API Tools
# http://aws.amazon.com/developertools/351
package 'openjdk-7-jre'

zip_file = "#{zip_path}/ec2-api-tools-1.6.9.0.zip"
remote_file zip_file do
  source 'http://s3.amazonaws.com/ec2-downloads/ec2-api-tools-1.6.9.0.zip'
  backup false
end

bash 'unarchive_source' do
  cwd  zip_path
  code 'unzip ec2-api-tools-1.6.9.0.zip -d /usr/local'
  not_if { ::File.directory?('/usr/local/ec2-api-tools-1.6.9.0') }
end

################################################################################
# CC-Server
timestamped_deploy '/opt/cc-server' do
  repo 'https://github.com/der-flo/aws-ha-cc-server.git'
  # TODO: Funktioniert das?
  # restart_command 'touch tmp/restart.txt'
  symlink_before_migrate.clear
  shallow_clone true
  keep_releases 3
  before_migrate do
    bash 'bundle-install-cc-server' do
      cwd release_path
      # http://chr4.org/blog/2013/07/31/chef-deploy-revision-and-capistrano-git-style/
      # TODO?
      code 'bundle install'# --deployment --path /opt/cc-server/shared/bundle'
    end
  end
end
cookbook_file '/etc/init/cc-server.conf'
service 'cc-server' do
  provider Chef::Provider::Service::Upstart
  supports status: false
  action [:enable, :start]
end
cookbook_file '/etc/init/cc-server-worker.conf'
service 'cc-server-worker' do
  provider Chef::Provider::Service::Upstart
  supports status: false
  action [:enable, :start]
end
