require 'test_helper'
require 'dhcp_common/dhcp_common'
require 'smart_proxy_dhcp_device42/plugin_configuration'
require 'smart_proxy_dhcp_device42/scheme_validator'
require 'smart_proxy_dhcp_device42/verify_validator'
require 'smart_proxy_dhcp_device42/module_loader'
require 'smart_proxy_dhcp_device42/dhcp_device42_plugin'
require 'smart_proxy_dhcp_device42/device42_api'
require 'smart_proxy_dhcp_device42/dhcp_device42_main'

class Device42DhcpProductionWiringTest < Test::Unit::TestCase
  def setup
    @settings = {:username => 'user', :password => 'password', 
                 :server => '10.10.10.10', :scheme => 'https', 
                 :verify => true, :subnets => ['1.1.1.0/255.255.255.0']}
    @container = ::Proxy::DependencyInjection::Container.new
    Proxy::DHCP::Device42::PluginConfiguration.new.load_dependency_injection_wirings(@container, @settings)
  end

  def test_connection_initialization
    connection = @container.get_dependency(:connection)
    assert_equal '10.10.10.10', connection.host
    assert_equal 'user', connection.username
    assert_equal 'password', connection.password
    assert_equal 'https', connection.scheme
    assert_equal true, connection.verify
  end

  def test_provider
    provider = @container.get_dependency(:dhcp_provider)
    assert provider.instance_of?(::Proxy::DHCP::Device42::Provider)
  end

end