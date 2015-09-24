module Wechat
  module Api
    #
    module User
      def user_info(openid, lang = 'zh_CN')
        get 'user/info', openid: openid, lang: lang
      end
    end
  end
end
