module Wechat
  #
  module Qy
  end
end

require 'wechat/qy/client'
require 'wechat/qy/message'

::Wechat::Qy::Client.send :include, ::Wechat::Qy::Message
