require 'bundler/setup'
require 'aws-sdk'
require 'open-uri'

# TODO: Refaktorieren
ec2 = AWS::EC2.new.regions['eu-west-1']
instance_id = open('http://169.254.169.254/latest/meta-data/instance-id').read
instance = ec2.instances[instance_id]
role = instance.tags.to_h['ROLE']

# Mit diesem speziellen Bundler-Aufruf wird die ENV dahingehend für den
# Subprozess gereinigt, dass innen nicht überall pauschal Bundler verwendet
# wird.
Bundler.clean_exec("chef-solo -c solo.rb -o 'recipe[testapp::#{role}]'")
