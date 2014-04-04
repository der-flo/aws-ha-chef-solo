#!/bin/sh

set -o errexit

# Sonst erkennt ohai die node nicht aus EC2-Instanz
echo '{}' > /etc/chef/ohai/hints/ec2.json

# Bundler wird eigentlich nicht benötigt, ist aber ein schöner Weg, um einige
# Gems zu installieren.
bundle install

berks install --path cookbooks
chef-solo -c solo.rb -l info -o 'recipe[testapp]'
