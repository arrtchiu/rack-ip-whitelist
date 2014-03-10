require "rack-ip-whitelist/version"

module Rack
  class IpWhitelist
    def initialize(app, addresses)
      @app = app
      @ip_addresses = addresses
    end

    def call(env)
      if white_listed?(env)
        @app.call(env)
      else
        [ 401, {"Content-Type" => "text/plain"}, ["Unauthorized."] ]
      end
    end
    
    def white_listed?(env)
      Rails.logger.info "WHITELIST: ENV: #{remote_address(env)}"
      Rails.env.production? ? @ip_addresses.include?(remote_address(env)) : true
    end
    
    def remote_address(env)
      if env["HTTP_X_FORWARDED_FOR"].blank?
        env["REMOTE_ADDR"]
      else
        env["HTTP_X_FORWARDED_FOR"]
      end
    end
  end
end
