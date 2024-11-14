# frozen_string_literal: true

module TiptopPay
  module Namespaces
    class Tokens < Base
      AmountNotProvided = Class.new(StandardError)
      TokenNotProvided = Class.new(StandardError)

      def charge(attributes)
        attributes.fetch(:amount) { raise AmountNotProvided.new("amount attribute is required") }
        attributes.fetch(:token) { raise TokenNotProvided.new("token attribute is required") }

        response = request(:charge, attributes)
        Transaction.new(response[:model])
      end

      def auth(attributes)
        attributes.fetch(:amount) { raise AmountNotProvided.new("amount attribute is required") }
        attributes.fetch(:token) { raise TokenNotProvided.new("token attribute is required") }

        response = request(:auth, attributes)
        Transaction.new(response[:model])
      end
    end
  end
end
