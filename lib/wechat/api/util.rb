require 'securerandom'
require 'digest/sha1'

module Wechat
  module Api
    #
    module Util
      def create_qrcode_temp(scene_id, expire_seconds = 60_480)
        params = {
          action_name: 'QR_SCENE',
          expire_seconds: expire_seconds,
          action_info: {
            scene: {
              scene_id: scene_id
            }
          }
        }
        post 'qrcode/create', params
      end

      def create_qrcode(scene_str)
        params = {
          action_name: 'QR_LIMIT_STR_SCENE',
          action_info: {
            scene: {
              scene_str: scene_str
            }
          }
        }

        post 'qrcode/create', params
      end

      def js_ticket
        res = get 'ticket/getticket', type: :jsapi
        res['ticket']
      end

      def sign(params)
        str = params.to_a.sort.map { |p| p.join('=') }.join('&')
        logger.debug { "to_sign: #{str}" }
        Digest::SHA1.hexdigest str
      end

      def js_config(url: nil)
        r = ticket.tap { |j| j.refresh if j.expired? }.ticket
        nonce = SecureRandom.hex
        timestamp = Time.now.to_i
        signature = sign(noncestr: nonce, timestamp: timestamp, jsapi_ticket: r, url: url)
        {
          appId: app_id, timestamp: timestamp, nonceStr: nonce,
          signature: signature
        }.tap { |hash| logger.debug { "js_config: #{hash}, url: #{url}" } }
      end
    end
  end
end
