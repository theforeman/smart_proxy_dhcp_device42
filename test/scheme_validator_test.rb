require 'test_helper'
require 'smart_proxy_dhcp_device42/scheme_validator'

class SchemeValidatorTest < Test::Unit::TestCase
  def setup
    @validator = ::Proxy::DHCP::Device42::SchemeValidator.new(:dhcp_device42, :scheme, nil, nil)
  end

  def test_should_pass_when_record_type_is_http
    assert @validator.validate!(:scheme => 'http')
  end

  def test_should_pass_when_record_type_is_https
    assert @validator.validate!(:scheme => 'https')
  end

  def test_should_raise_exception_when_record_type_is_unrecognised
    assert_raises(::Proxy::Error::ConfigurationError) { @validator.validate!(:scheme => '') }
  end
end