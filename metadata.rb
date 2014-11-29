name             "flume"

maintainer       "javierarrieta"
maintainer_email "jarrieta@gilt.com"
license          "Apache"
description      "Installs and configures flume"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

depends 'ark', '>= 0.2.4'

recommends 'build-essential'
recommends 'xml'
recommends 'java'
recommends 'monit'

provides 'flume'
provides 'flume::elasticsearch'
provides 'flume::newrelic'
