# frozen_string_literal: true

require "tiptop_pay/client/errors"
require "tiptop_pay/client/gateway_errors"
require "tiptop_pay/client/response"
require "tiptop_pay/client/serializer"

module TiptopPay
  class Client
    include Namespaces

    attr_reader :config, :connection

    def initialize(config = nil)
      @config = config || TiptopPay.config
      @connection = build_connection
    end

    def perform_request(path, params = nil)
      response = connection.post(path, (params ? convert_to_json(params) : nil), headers)

      Response.new(response.status, response.body, response.headers).tap do |response|
        raise_transport_error(response) if response.status.to_i >= 300
      end
    end

    private

    def convert_to_json(data)
      config.serializer.dump(data)
    end

    def headers
      {"Content-Type" => "application/json"}
    end

    def logger
      config.logger
    end

    def raise_transport_error(response)
      logger.fatal "[#{response.status}] #{response.origin_body}" if logger
      error = ERRORS[response.status] || ServerError
      raise error.new "[#{response.status}] #{response.origin_body}"
    end

    def build_connection
      Faraday::Connection.new(config.host, config.connection_options) do |conn|
        conn.request :basic_auth, config.public_key, config.secret_key
        config.connection_block.call(conn) if config.connection_block
      end
    end
  end
end