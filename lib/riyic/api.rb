require 'net/http'

module Riyic
    class API
        PROD_URL = 'http://www2.ruleyourcloud.com'
        TEST_URL = 'http://10.0.3.1:3000'
        
        def self.base_url(env='test')
            (env == 'prod')? PROD_URL : TEST_URL
        end

        def initialize(api_key, server_id, env = 'test')
            @api_key = api_key
            @server_id = server_id
            @enviroment = env

            @base_url = (env == 'prod')? PROD_URL : TEST_URL
        end

        def get_server_config
            uri = URI("#{@base_url}/admin/servers/#{@server_id}/generate_config?auth_token=#{@api_key}")
            puts "api call: #{uri}" if $debug
            http = Net::HTTP.new(uri.host, uri.port)
            #http.use_ssl = true
                
            req = Net::HTTP::Get.new(uri.request_uri)
            resp = http.request(req)

            puts resp.inspect if $debug
            resp.body
                
        end

    end
end
