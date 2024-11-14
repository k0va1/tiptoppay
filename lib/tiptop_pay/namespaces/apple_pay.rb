# frozen_string_literal: true

module TiptopPay
  module Namespaces
    class ApplePay < Base
      ValidationUrlNotProvided = Class.new(StandardError)

      def self.resource_name
        "applepay"
      end

      def start_session(attributes)
        attributes.fetch(:validation_url) { raise ValidationUrlNotProvided.new("validation_url is required") }

        response = request(:startsession, attributes)
        AppleSession.new(response[:model])
      end
    end
  end
end
