module ::Proxy::DHCP::Device42
  class VerifyValidator < ::Proxy::PluginValidators::Base
    def validate!(settings)
      return true if [true, false].include?(settings[:verify])
      raise ::Proxy::Error::ConfigurationError, "Setting 'verify' can be set to either 'true' or 'false' ( bool )"
    end
  end
end