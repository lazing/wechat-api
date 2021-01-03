require 'wechat/api/client'

#
module Wechat
  #
  module Api
    class Error < StandardError; end
    
    def self.client(appid = 'origin_id')
      var = "@_client_#{appid}"
      if instance_variable_defined?(var)
        instance_variable_get(var)
      elsif block_given?
        c = yield(Client)
        instance_variable_set var, c
      else
        raise Error, :not_initialized
      end
    end
  end
end
