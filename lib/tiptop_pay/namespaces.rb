# frozen_string_literal: true

require "tiptop_pay/namespaces/base"
require "tiptop_pay/namespaces/cards"
require "tiptop_pay/namespaces/tokens"
require "tiptop_pay/namespaces/payments"
require "tiptop_pay/namespaces/subscriptions"
require "tiptop_pay/namespaces/orders"
require "tiptop_pay/namespaces/kassa"
require "tiptop_pay/namespaces/apple_pay"

module TiptopPay
  module Namespaces
    def payments
      Payments.new(self)
    end

    def kassa
      Kassa.new(self)
    end

    def subscriptions
      Subscriptions.new(self)
    end

    def orders
      Orders.new(self)
    end

    def apple_pay
      ApplePay.new(self)
    end

    def ping
      !!(perform_request("/test").body || {})[:success]
    rescue ::Faraday::ConnectionFailed, ::Faraday::TimeoutError, TiptopPay::Client::ServerError
      false
    end
  end
end
