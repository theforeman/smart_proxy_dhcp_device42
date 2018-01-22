require 'mocha'
require 'test_helper'
require 'dhcp_common/dhcp_common'
require 'dhcp_common/subnet'
require 'smart_proxy_dhcp_device42/dhcp_device42_main'

class Device42ProviderTest < Test::Unit::TestCase
  def setup
    @connection = Device42.new('127.0.0.1', 'https', true,
                               'user', 'password')
    @managed_subnets = nil

    @d42_api_response_subnet = {
      'network' => '192.168.42.0', 
      'mask_bits' => '24'
    }
    @record = {
      'name' => 'test',
      'ip_address' => '192.168.42.1',
      'network' => '192.168.42.0',
      'mask_bits' => '24',
      'hwaddress' => '32e760a64061',
    }
    @subnet = Proxy::DHCP::Subnet.new('192.168.42.0', '255.255.255.0')
    @subnet2 = Proxy::DHCP::Subnet.new('192.168.42.0', '0.0.0.0')
    @provider = Proxy::DHCP::Device42::Provider.new(@connection, @managed_subnets)
    @reservation = Proxy::DHCP::Reservation.new('test', '192.168.42.1', '32:e7:60:a6:40:61', @subnet, {:hostname => 'test'})
    @reservation2 = Proxy::DHCP::Reservation.new('test', '192.168.42.1', '32:e7:60:a6:40:61', @subnet2, {:hostname => 'test'})
  end

  def test_connection_initialization
    assert_equal @connection, @provider.connection
    assert_equal Set[], @provider.managed_subnets
  end

  def test_cidr_to_ip_mask
    assert_equal '255.255.255.0', @provider.cidr_to_ip_mask('24'.to_i)
  end

  def test_build_reservation
    assert_equal @reservation, @provider.build_reservation(@record)

    record1 = @record.select{|x| x != 'name'}
    record2 = @record.select{|x| x != 'ip_address'}
    record3 = @record.select{|x| x != 'network'}
    record4 = @record.select{|x| x != 'mask_bits'}
    record5 = @record.select{|x| x != 'hwaddress'}
    assert_equal nil, @provider.build_reservation(record1)
    assert_raises(Proxy::Validations::Error) { @provider.build_reservation(record2) }
    assert_raises(Proxy::Validations::Error) { @provider.build_reservation(record3) }
    assert_equal @reservation2, @provider.build_reservation(record4)
    assert_equal nil, @provider.build_reservation(record5)
    assert_equal nil, @provider.build_reservation({})
  end

  def test_subnets
    @connection.stubs(:get_subnets).returns([@d42_api_response_subnet])
    assert_equal [@subnet], @provider.subnets

    @connection.stubs(:get_subnets).returns([])
    assert_equal [], @provider.subnets
  end

  def test_unused_ip
    ip = {'ip_address': '192.168.42.1'}
    @connection.stubs(:get_next_ip).returns(ip)
    assert_equal ip, @provider.unused_ip(nil, nil, nil, nil)
  end

  def test_find_records_by_ip
    @connection.stubs(:get_hosts_by_ip).returns([@record])
    assert_equal [@reservation], @provider.find_records_by_ip(nil, nil)

    @connection.stubs(:get_hosts_by_ip).returns([])
    assert_equal [], @provider.find_records_by_ip(nil, nil)
  end

  def test_find_record_by_mac
    @connection.stubs(:get_host_by_mac).returns([@record])
    assert_equal @reservation, @provider.find_record_by_mac(nil, nil)

    @connection.stubs(:get_host_by_mac).returns([])
    assert_equal nil, @provider.find_record_by_mac(nil, nil)
  end

  def test_add_record
    @connection.stubs(:add_host).returns(nil)
    assert_equal nil, @provider.add_record(nil)
  end

  def test_del_record
    @connection.stubs(:remove_host).returns(nil)
    assert_equal nil, @provider.del_record(@reservation)
  end

end