require 'multi_json'
require 'wechat/api/message'
require 'wechat/api/user'
require 'wechat/api/util'
require 'faraday'
require 'logger'

module Wechat
  module Api
    #
    class ResponseError < StandardError; end
    class AccessTokenExpiredError < ResponseError; end
    #
    class Client
      include Message
      include User
      include Util

      API_BASE = 'https://api.weixin.qq.com/cgi-bin/'

      attr_reader :app_id, :secret
      attr_accessor :logger

      def initialize(app_id, secret)
        @app_id, @secret = app_id, secret
        @logger = Logger.new(STDOUT)
        @token_file = File.join('/tmp', "wechat-api-#{app_id}")
      end

      def access_token
        @access_token ||= begin
          token = MultiJson.load(File.read(@token_file))
          token['access_token']
        rescue
          refresh
        end
      end

      def refresh
        logger.debug { 'refresh token' }
        url = format('%stoken', API_BASE)
        resp = connection.get(url, token_params)
        response = MultiJson.load(resp.body)
        return handle_error(response) if response['errcode']
        token = response['access_token']
        File.open(@token_file, 'w') { |f| f.write(resp.body) } if token
        token
      end

      def get(uri, params = {})
        with_access_token(uri, params) do |url, params_with_token|
          debug_request do
            connection.get do |req|
              req.url url, params_with_token
              req.headers[:accept] = 'application/json'
              req.headers[:content_type] = 'application/json'
            end
          end
        end
      end

      def post(uri, data = {})
        with_access_token(uri, {}) do |url, params|
          debug_request do
            connection.post do |req|
              req.url url, params
              req.headers[:accept] = 'application/json'
              req.headers[:content_type] = 'application/json'
              req.body = MultiJson.dump(data)
            end
          end
        end
      end

      def with_access_token(uri, params, tried = 2)
        url = format('%s%s', API_BASE, uri)
        begin
          resp = yield(url, params.merge(access_token: access_token))
          response = MultiJson.load(resp.body)
          handle_error(response)
        rescue AccessTokenExpiredError => e
          refresh
          retry unless (tried -= 1).zero?
          raise e
        end
      end

      private

      def debug_request
        response = yield
        logger.debug { response }
        response
      end

      def handle_error(response)
        case response['errcode']
        when 0, nil
          response
        when 40_001, 42_001, 40_014
          fail AccessTokenExpiredError, response
        else
          fail ResponseError, response
        end
      end

      def token_params
        {
          grant_type: 'client_credential',
          appid: app_id,
          secret: secret
        }
      end

      def connection
        @connection ||= begin
          Faraday.new do |faraday|
            faraday.adapter Faraday.default_adapter
          end
        end
      end
    end
  end
end
