module Proxy::DHCP::Device42
  class Plugin < ::Proxy::Provider
    plugin :dhcp_device42, ::Proxy::DHCP::Device42::VERSION

    validate_presence :username, :password

    requires :dhcp, '>= 1.16'

    load_classes ::Proxy::DHCP::Device42::PluginConfiguration
    load_dependency_injection_wirings ::Proxy::DHCP::Device42::PluginConfiguration
  end
end
