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
    end
  end
end
