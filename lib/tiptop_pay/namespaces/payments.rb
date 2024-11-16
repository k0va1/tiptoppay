# frozen_string_literal: true

module TiptopPay
  module Namespaces
    class Payments < Base
      IdNotProvided = Class.new(StandardError)
      AmountNotProvided = Class.new(StandardError)
      CurrencyNotProvided = Class.new(StandardError)
      DateNotProvided = Class.new(StandardError)

      def cards
        Cards.new(client, resource_path)
      end

      def tokens
        Tokens.new(client, resource_path)
      end

      def confirm(attributes)
        id = attributes.fetch(:id) { raise IdNotProvided.new("id attribute is required") }
        amount = attributes.fetch(:amount) { raise AmountNotProvided.new("amount attribute is required") }

        request(:confirm, transaction_id: id, amount: amount)[:success]
      end

      def void(id)
        request(:void, transaction_id: id)[:success]
      end

      alias_method :cancel, :void

      def refund(attributes)
        id = attributes.fetch(:id) { raise IdNotProvided.new("id attribute is required") }
        amount = attributes.fetch(:amount) { raise AmountNotProvided.new("amount attribute is required") }

        request(:refund, transaction_id: id, amount: amount)[:success]
      end

      def get(id)
        response = request(:get, transaction_id: id)
        Transaction.new(response[:model])
      end

      def find(invoice_id)
        response = request(:find, invoice_id: invoice_id)
        Transaction.new(response[:model])
      end

      def list(attributes)
        attributes.fetch(:date) { raise DateNotProvided.new("date attribute is required") }

        response = request(:list, attributes)
        Array(response[:model]).map { |model| Transaction.new(model) }
      end
    end
  end
end
