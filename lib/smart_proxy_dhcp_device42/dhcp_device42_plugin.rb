module Proxy::DHCP::Device42
  class Plugin < ::Proxy::Provider
    plugin :dhcp_device42, ::Proxy::DHCP::Device42::VERSION

    validate_presence :username, :password, :server, :scheme, :verify

    requires :dhcp, '>= 1.16'

    load_classes ::Proxy::DHCP::Device42::PluginConfiguration
    load_dependency_injection_wirings ::Proxy::DHCP::Device42::PluginConfiguration

    load_validators :scheme_validator => ::Proxy::DHCP::Device42::SchemeValidator
    load_validators :verify_validator => ::Proxy::DHCP::Device42::VerifyValidator

    validate :scheme, :scheme_validator => true
    validate :verify, :verify_validator => true
  end
end
