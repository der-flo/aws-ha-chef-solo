name             'testapp'
maintainer       'Florian Dütsch'
maintainer_email 'florian.duetsch@nix-wie-weg.de'
license          'All rights reserved'
description      'Installs/Configures testapp'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'nginx'
