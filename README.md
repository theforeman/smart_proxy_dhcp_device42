# SmartProxyDhcpDevice42

This plugin adds a new DHCP provider for managing records with device42 servers

## Installation

See [How_to_Install_a_Smart-Proxy_Plugin](http://projects.theforeman.org/projects/foreman/wiki/How_to_Install_a_Smart-Proxy_Plugin)
for how to install Smart Proxy plugins

This plugin is compatible with Smart Proxy 1.11 or higher.

When installing using "gem", make sure to install the bundle file:

    echo "gem 'smart_proxy_dhcp_device42'" > /usr/share/foreman-proxy/bundler.d/dhcp_device42.rb

## Configuration

To enable this DHCP provider, edit `/etc/foreman-proxy/settings.d/dhcp.yml` and set:

    :use_provider: dhcp_device42
    :server: IP of device42 server
    :subnets: subnets you want to use (optional unless you set device42_subnets to false)

Configuration options for this plugin are in `/etc/foreman-proxy/settings.d/dhcp_device42.yml` and include:

    :username: API Username
    :password: API Password

## Contributing

Fork and send a Pull Request. Thanks!

## Copyright

Copyright (c) 2018 Device42, Inc.

