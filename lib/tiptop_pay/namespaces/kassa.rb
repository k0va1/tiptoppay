# frozen_string_literal: true

module TiptopPay
  module Namespaces
    class Kassa < Base
      IdNotProvided = Class.new(StandardError)
      InnNotProvided = Class.new(StandardError)
      TypeNotProvided = Class.new(StandardError)
      CustomerReceiptNotProvided = Class.new(StandardError)

      def self.resource_name
        "kkt"
      end

      def receipt(attributes)
        attributes.fetch(:inn) { raise InnNotProvided.new("inn attribute is required") }
        attributes.fetch(:type) { raise TypeNotProvided.new("type attribute is required") }
        attributes.fetch(:customer_receipt) { raise CustomerReceiptNotProvided.new("customer_receipt is required") }

        request(:receipt, attributes)
      end

      def receipt_status(attributes)
        attributes.fetch(:id) { raise IdNotProvided.new("id attribute is required") }

        request("receipt/status/get", attributes)
      end

      def fetch_receipt(attributes)
        attributes.fetch(:id) { raise IdNotProvided.new("id attribute is required") }

        request("receipt/get", attributes)
      end
    end
  end
end
