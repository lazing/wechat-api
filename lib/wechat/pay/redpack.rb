require 'securerandom'

module Wechat
  module Pay
    #
    module Redpack
      def redpack(transaction_id, openid, params = {})
        post\
          '/mmpaymkttransfers/sendredpack',
          params.merge(
            mch_billno: transaction_id, wxappid: @wxappid, re_openid: openid
          )
      end

      def group_redpack(transaction_id, openid, params = {})
        post\
          '/mmpaymkttransfers/sendgroupredpack',
          params.merge(
            mch_billno: transaction_id, wxappid: @wxappid, re_openid: openid
          )
      end

      def redpack_info(transaction_id)
        post\
          '/mmpaymkttransfers/gethbinfo',
          mch_billno: transaction_id, bill_type: 'MCHT', appid: @wxappid
      end

      private
    end
  end
end
