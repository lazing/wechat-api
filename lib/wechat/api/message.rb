module Wechat
  module Api
    #
    module Message
      def send_template(tmp_id, openid, url, data = {})
        params = {
          touser: openid,
          template_id: tmp_id,
          url: url,
          data: data
        }
        post 'message/template/send', params
      end
    end
  end
end
