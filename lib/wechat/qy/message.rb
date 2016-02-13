module Wechat
  module Qy
    module Message
      # text_send('appid', 'hello', touser: 'User1|User2')
      def text_send(agent_id, content, data = {})
        params = {
          msgtype: :text,
          agentid: agent_id,
          safe: 0,
          text: { content: content }
        }.merge(data)
        post 'message/send', params
      end
    end
  end
end
