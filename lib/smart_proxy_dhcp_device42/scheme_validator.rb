module ::Proxy::DHCP::Device42
  class SchemeValidator < ::Proxy::PluginValidators::Base
    def validate!(settings)
      return true if ['http', 'https'].include?(settings[:scheme])
      raise ::Proxy::Error::ConfigurationError, "Setting 'scheme' can be set to either 'http' or 'https'"
    end
  end
end