require File.expand_path('../lib/smart_proxy_dhcp_device42/dhcp_device42_version', __FILE__)
require 'date'

Gem::Specification.new do |s|
  s.name        = 'smart_proxy_dhcp_device42'
  s.version     = Proxy::DHCP::Device42::VERSION
  s.date        = Date.today.to_s
  s.license     = 'GPL-3.0'
  s.authors     = ['Anatolii Chmykhalo']
  s.email       = ['anatolii.chmykhalo@device42.com']
  s.homepage    = 'https://www.device42.com'

  s.summary     = "Device42 DHCP provider plugin for Foreman's smart proxy"
  s.description = "Device42 DHCP provider plugin for Foreman's smart proxy"

  s.files       = Dir['{config,lib,bundler.d}/**/*'] + ['README.md', 'LICENSE']
  s.add_runtime_dependency 'httparty', '~> 0.15'
end
