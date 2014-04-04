require 'aws-sdk'

ec2 = AWS::EC2.new.regions['eu-west-1']
str = ec2.instances[node[:ec2][:instance_id]].tags.to_h['ROLES']
default[:ec2][:roles] = (str || '').split(',')
