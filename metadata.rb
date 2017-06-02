name 'consul-docker'
maintainer 'Jacob McCann'
maintainer_email 'jacob.mccann2@target.com'
license 'Apache-2.0'
description 'Installs/Configures consul-docker'
long_description 'Installs/Configures consul-docker'
version '0.3.0'
chef_version '>= 12.1' if respond_to?(:chef_version)

source_url 'https://github.com/jmccann/consul-docker-cookbook'
issues_url 'https://github.com/jmccann/consul-docker-cookbook/issues'

depends 'jmccann-docker-host', '~> 3.0'
