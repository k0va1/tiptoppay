# frozen_string_literal: true

require "openssl"
require "base64"

module TiptopPay
  class Webhooks
    class HMACError < StandardError; end

    attr_reader :config

    def initialize(config = nil)
      @config = config || TiptopPay.config
      @digest = OpenSSL::Digest.new("sha256")
      @serializer = Client::Serializer::Base.new(config)
    end

    def data_valid?(data, hmac)
      Base64.decode64(hmac) == OpenSSL::HMAC.digest(@digest, config.secret_key, data)
    end

    def validate_data!(data, hmac)
      raise HMACError unless data_valid?(data, hmac)
      true
    end

    def on_kassa_receipt(data)
      OnKassaReceipt.new(@serializer.load(data))
    end

    def on_recurrent(data)
      OnRecurrent.new(@serializer.load(data))
    end

    def on_pay(data)
      OnPay.new(@serializer.load(data))
    end

    def on_fail(data)
      OnFail.new(@serializer.load(data))
    end

    def on_check(data)
      OnCheck.new(@serializer.load(data))
    end

    def on_cancel(data)
      OnCancel.new(@serializer.load(data))
    end

    def on_confirm(data)
      OnConfirm.new(@serializer.load(data))
    end

    def on_refund(data)
      OnRefund.new(@serializer.load(data))
    end
  end
end
