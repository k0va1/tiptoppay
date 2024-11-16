# frozen_string_literal: true

module TiptopPay
  module Namespaces
    class Tokens < Base
      AmountNotProvided = Class.new(StandardError)
      TokenNotProvided = Class.new(StandardError)
      AccountIdNotProvided = Class.new(StandardError)
      CurrencyNotProvided = Class.new(StandardError)
      PageNumberNotProvided = Class.new(StandardError)

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

      def topup(attributes)
        attributes.fetch(:token) { raise TokenNotProvided.new("token attribute is required") }
        attributes.fetch(:amount) { raise AmountNotProvided.new("amount attribute is required") }
        attributes.fetch(:account_id) { raise AccountIdNotProvided.new("account_id attribute is required") }
        attributes.fetch(:currency) { raise CurrencyNotProvided.new("currency attribute is required") }

        response = request(:topup, attributes)
        Transaction.new(response[:model])
      end

      def list(attributes)
        attributes.fetch(:page_number) { raise PageNumberNotProvided.new("page_number attribute is required") }

        response = request(:list, attributes)
        Array(response[:model]).map { |model| Token.new(model) }
      end
    end
  end
end
