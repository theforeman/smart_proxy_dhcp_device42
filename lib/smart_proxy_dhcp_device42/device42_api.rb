require "httparty"
require "ipaddr"
require "json"
require "csv"

class Device42

    attr_reader :host, :scheme, :username, :password
    def initialize(host, scheme, username, password)
      @host = host
      @scheme = scheme
      @username = username
      @password = password
    end

    def csv_to_array(csv_string)
      csv = CSV::parse(csv_string)
      fields = csv.shift
      fields = fields.map {|f| f.downcase.gsub(" ", "_")}
      csv.collect { |record| Hash[*fields.zip(record).flatten ] } 
    end

    def rest_get(endpoint, querystring)
      response = HTTParty.get("%s://%s/api/1.0/%s/%s" % [@scheme, @host, endpoint, querystring], {
                                :headers => {
                                  'Content-Type' => 'application/x-www-form-urlencoded',
                                  'charset' => 'utf-8'
                                },
                                :basic_auth => { :username => @username, :password => @password },
                                :verify => false
                           })
      return response.body
    end

    def rest_post(endpoint, body)
      response = HTTParty.post("%s://%s/api/1.0/%s/" % [@scheme, @host, endpoint], {
                                :body => body,
                                :headers => {
                                  'Content-Type' => 'application/x-www-form-urlencoded',
                                  'charset' => 'utf-8'
                                },
                                :basic_auth => { :username => @username, :password => @password },
                                :verify => false
                              })
      return response.body
    end

    def rest_delete(endpoint, id)
      response = HTTParty.delete("%s://%s/api/1.0/%s/%s/" % [@scheme, @host, endpoint, id], {
                                :basic_auth => { :username => @username, :password => @password },
                                :verify => false
                              })
      return response.body
    end

    def doql(query)
      response = HTTParty.post("%s://%s/services/data/v1.0/query/" % [@scheme, @host], {
                                :body => {
                                  :header => 'yes',
                                  :query => query
                                },
                                :headers => {
                                  'Content-Type' => 'application/x-www-form-urlencoded',
                                  'charset' => 'utf-8'
                                },
                                :basic_auth => { :username => @username, :password => @password },
                                :verify => false
                              })
      return response.body
    end

    def add_host(options)
      device = {
        :name => options['name']
      }
      rest_post('devices', device)
      
      ip = {
        :ipaddress => options['ip'],
        :macaddress => options['mac'],
        :device => options['name']
      }
      rest_post('ips', ip)
    end

    def remove_host(name)
      device = {
        :name => name
      }
      response = JSON.parse(rest_post('devices', device))
      device_id = response['msg'][1]
      rest_delete('devices', device_id)
    end

    def get_hosts_by_ip(ip)
      csv = doql("SELECT d.name, i.ip_address, n.hwaddress, s.network, s.mask_bits FROM view_ipaddress_v1 i
                  JOIN view_device_v1 d ON d.device_pk = i.device_fk
                  JOIN view_netport_v1 n ON n.netport_pk = i.netport_fk
                  JOIN view_subnet_v1 s ON i.subnet_fk = s.subnet_pk
                  WHERE i.ip_address in ('%s')
                  AND i.available = False" % ip)
      return csv_to_array(csv)
    end

    def get_host_by_mac(mac)
      mac = mac.split(':').join
      csv = doql("SELECT d.name, i.ip_address, n.hwaddress, s.network, s.mask_bits FROM view_netport_v1 n
                  JOIN view_ipaddress_v1 i ON n.netport_pk = i.netport_fk
                  JOIN view_subnet_v1 s ON i.subnet_fk = s.subnet_pk
                  JOIN view_device_v1 d ON d.device_pk = n.device_fk
                  WHERE n.hwaddress in ('%s')
                  AND i.available = False LIMIT 1" % mac)
      data = csv_to_array(csv)
      return [] if data.empty?
      data
    end

    def get_subnets()
      csv = doql("SELECT network, mask_bits FROM view_subnet_v1")
      return csv_to_array(csv)
    end

    def get_subnet(network)
      csv = doql("SELECT subnet_pk, network, mask_bits FROM view_subnet_v1 WHERE network in ('%s') LIMIT 1" % network)
      subnet = csv_to_array(csv)
      return nil if subnet.empty?
      subnet
    end

    def get_next_ip(network, start_ip, end_ip)
      subnet = get_subnet(network)
      return nil if subnet == nil
      ip = JSON.parse(rest_get('suggest_ip', '?subnet_id=%s&start_range=%s&end_range=%s' % [subnet[0]['subnet_pk'], start_ip, end_ip]))
      ip['ip'] 
    end

end
