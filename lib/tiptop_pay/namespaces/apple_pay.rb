# frozen_string_literal: true

module TiptopPay
  module Namespaces
    class ApplePay < Base
      ValidationUrlMissing = Class.new(StandardError)

      def self.resource_name
        "applepay"
      end

      def start_session(attributes)
        validation_url = attributes.fetch(:validation_url) { raise ValidationUrlMissing.new("validation_url is required") }
        payment_url = attributes.fetch(:payment_url)

        request_attrs = {"ValidationUrl" => validation_url}
        request_attrs["PaymentUrl"] = payment_url if payment_url
        request(:startsession, request_attrs)
      end
    end
  end
end
