require File.expand_path('../lib/smart_proxy_dhcp_device42/dhcp_device42_version', __FILE__)
require 'date'

Gem::Specification.new do |s|
  s.name        = 'smart_proxy_dhcp_device42'
  s.version     = Proxy::DHCP::Device42::VERSION
  s.date        = Date.today.to_s
  s.license     = 'APACHE-2'
  s.authors     = ['Anatolii Chmykhalo']
  s.email       = ['anatolii.chmykhalo@device42.com']
  s.homepage    = 'https://www.device42.com'

  s.summary     = "Device42 DHCP provider plugin for Foreman's smart proxy"
  s.description = "Device42 DHCP provider plugin for Foreman's smart proxy"

  s.files       = Dir['{config,lib,bundler.d}/**/*'] + ['README.md', 'LICENSE']
  s.add_runtime_dependency('httparty', '0.0.7')
  s.add_runtime_dependency('json', '1.8.3')
end
