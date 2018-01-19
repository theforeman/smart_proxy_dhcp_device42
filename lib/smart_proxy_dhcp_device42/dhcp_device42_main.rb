require 'dhcp_common/server'

module Proxy::DHCP::Device42
  class Provider < ::Proxy::DHCP::Server
    include Proxy::Log
    include Proxy::Util

    attr_reader :connection

    def initialize(connection, managed_subnets)
      @connection = connection
      @managed_subnets = managed_subnets
      super('device42', managed_subnets, nil)
    end

    def cidr_to_ip_mask(prefix_length)
      bitmask = 0xFFFFFFFF ^ (2 ** (32-prefix_length) - 1)
      (0..3).map {|i| (bitmask >> i*8) & 0xFF}.reverse.join('.')
    end

    def build_reservation(record)
      return nil if record.empty?
      return nil if record['name'].nil? || record['name'].empty?
      return nil if record['hwaddress'].nil? || record['hwaddress'].empty?

      mac = record['hwaddress']
      mac = mac.gsub(/(.{2})/, '\1:')[0...-1]
      opts = {:hostname => record['name']}
      subnet = ::Proxy::DHCP::Subnet.new(record['network'], cidr_to_ip_mask(record['mask_bits'].to_i))
      Proxy::DHCP::Reservation.new(record['name'], record['ip_address'], mac, subnet, opts)
    end

    def subnets
      difined_subnets = []
      @connection.get_subnets().each do |subnet|
        address = subnet['network']
        if !['::'].include? address
          if subnet['mask_bits'].to_i <= 32
            netmask = cidr_to_ip_mask(subnet['mask_bits'].to_i)
            if managed_subnet?("#{address}/#{netmask}")
              difined_subnets.push(Proxy::DHCP::Subnet.new(address, netmask, {}))
            end
          end
        end
      end.compact
      difined_subnets
    end

    def unused_ip(subnet, _, from_ip_address, to_ip_address)
      @connection.get_next_ip(subnet, from_ip_address, to_ip_address)
    end

    def find_records_by_ip(subnet_address, ip)
      records = @connection.get_hosts_by_ip(ip)
      return [] if records.empty?
      reservs = []
      records.each do |record|
        reserv = build_reservation(record)
        reservs.push(reserv) if !reserv.nil?
      end
      reservs
    end

    def find_record_by_mac(subnet_address, mac_address)
      record = @connection.get_host_by_mac(mac_address)
      return nil if record.empty?
      build_reservation(record[0])
    end

    def add_record(options)
      @connection.add_host(options)
    end

    def del_record(record)
      @connection.remove_host(record.name)
    end

  end
end
