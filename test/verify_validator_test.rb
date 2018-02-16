require 'test_helper'
require 'smart_proxy_dhcp_device42/verify_validator'

class VerifyValidatorTest < Test::Unit::TestCase
  def setup
    @validator = ::Proxy::DHCP::Device42::VerifyValidator.new(:dhcp_device42, :verify, nil, nil)
  end

  def test_should_pass_when_record_type_is_true
    assert @validator.validate!(:verify => true)
  end

  def test_should_pass_when_record_type_is_false
    assert @validator.validate!(:verify => false)
  end

  def test_should_raise_exception_when_record_type_is_unrecognised
    assert_raises(::Proxy::Error::ConfigurationError) { @validator.validate!(:verify => '') }
  end
end