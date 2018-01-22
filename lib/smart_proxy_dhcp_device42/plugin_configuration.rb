module Proxy::DHCP::Device42
  class PluginConfiguration
    def load_classes
      require 'dhcp_common/dhcp_common'
      require 'smart_proxy_dhcp_device42/device42_api'
      require 'smart_proxy_dhcp_device42/dhcp_device42_main'
    end

    def load_dependency_injection_wirings(c, settings)


      c.dependency :connection, (lambda do
                                  Device42.new(
                                    settings[:server],
                                    settings[:scheme],
                                    settings[:verify],
                                    settings[:username],
                                    settings[:password])
                                  end)

      c.dependency :dhcp_provider, (lambda do
                                      ::Proxy::DHCP::Device42::Provider.new(
                                        c.get_dependency(:connection),
                                        settings[:subnets])
                                      end)
    end
  end
end
