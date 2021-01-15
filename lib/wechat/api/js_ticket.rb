module Wechat
  module Api

    class JsTicket
      attr_reader :client, :ticket, :expires_at
      def initialize(client)
        @client = client
      end

      def refresh
        js = client.js_ticket
        @ticket = js['ticket']
        @expires_at = DateTime.now + Rational(js['expires_in'].to_i, 3600 * 24)
        self
      end

      def expired?
        expires_at.nil? || DateTime.now > expires_at
      end
    end
  end
end
