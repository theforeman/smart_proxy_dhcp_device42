class ::Proxy::DHCP::Device42::ModuleLoader < ::Proxy::DefaultModuleLoader
  def log_provider_settings(settings)
    super(settings)
    logger.warn("http is used for connection to Device42 appliance") if settings[:scheme] != 'https' 
  end
end