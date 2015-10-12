require 'rest-client'
require 'logger'
require 'multi_json'
require 'openssl'
require 'nori'
require 'gyoku'

require 'wechat/pay/redpack'

module Wechat
  module Pay
    class PayError < StandardError; end
    class NoAuthError < PayError; end
    class NotEnoughError < PayError; end
    class TimeLimitedError < PayError; end
    class MoneyLimitedError < PayError; end

    #
    class Client
      include Redpack
      BASE_URL = 'https://api.mch.weixin.qq.com'
      REQUIRED_OPTS = %w(key password cert sign_key).map(&:to_sym).freeze
      ERRORS = {
        'NO_AUTH' => NoAuthError,
        'NOTENOUGH' => NotEnoughError,
        'TIME_LIMITED' => TimeLimitedError,
        'MONEY_LIMITED' => MoneyLimitedError
      }

      attr_accessor :logger

      def initialize(mch_id, wxappid, opts = {})
        @mch_id = mch_id
        @wxappid = wxappid
        @opts = opts.map { |k, v| [k.to_sym, v] }.to_h
        unless (REQUIRED_OPTS - @opts.keys).empty?
          fail format('%s required', REQUIRED_OPTS.join(','))
        end
        @logger = Logger.new(STDOUT)
        rsa_setup
        @parser = Nori.new
      end

      def post(path, params)
        merged_params = merge(params)
        logger.debug { merged_params }
        resp = resource(path).post xml(sign(merged_params))
        handle(resp)
      end

      private

      def handle(resp)
        response = parser.parse(resp)
        check(response)
        response
      end

      def check(r)
        return if r['xml']['result_code'] == 'SUCCESS'
        handle_error(r['xml']['err_code'], r)
      end

      def handle_error(error_code, response)
        fail ERRORS[error_code] || PayError, response.inspect
      end

      def rsa_setup
        @rsa_key = OpenSSL::PKey::RSA.new @opts[:key], @opts[:password]
        @rsa_cert = OpenSSL::X509::Certificate.new @opts[:cert]
      rescue StandardError => e
        logger.error { e.inspect }
      end

      def resource(path)
        RestClient.log = logger
        RestClient::Resource.new\
          [BASE_URL, path].join,
          ssl_client_key: @rsa_key,
          ssl_client_cert: @rsa_cert,
          verify_ssl: OpenSSL::SSL::VERIFY_NONE
      end

      def xml(hash)
        Gyoku.xml({ xml: hash }, key_converter: :none)
      end

      def sign(params)
        ordered = trim_and_sort(params)
        keystr = format('key=%s', @opts[:sign_key])
        origin =
          ordered.map { |k, v| [k, v].join('=') }.push(keystr).join('&')
        sign = Digest::MD5.hexdigest(origin).upcase
        logger.debug { format('origin: %s, sign: %s', origin, sign) }
        params.merge(sign: sign)
      end

      def trim_and_sort(params)
        params.delete_if { |_k, v| v.blank? }
        params.sort.to_h
      end

      def merge(params)
        params.reverse_merge\
          mch_id: @mch_id,
          nonce_str: nonce_str
      end

      def nonce_str
        SecureRandom.hex
      end
    end
  end
end
