# frozen_string_literal: true

module TiptopPay
  module Namespaces
    class Payments < Base
      IdNotProvided = Class.new(StandardError)
      AmountNotProvided = Class.new(StandardError)
      CurrencyNotProvided = Class.new(StandardError)
      CardCryptogramPacketNotProvided = Class.new(StandardError)
      TokenNotProvided = Class.new(StandardError)
      AccountIdNotProvided = Class.new(StandardError)
      DateNotProvided = Class.new(StandardError)
      PageNumberNotProvided = Class.new(StandardError)
      CreatedDateGteNotProvided = Class.new(StandardError)
      CreatedDateLteNotProvided = Class.new(StandardError)

      def cards
        Cards.new(client, resource_path)
      end

      def tokens
        Tokens.new(client, resource_path)
      end

      def confirm(attributes)
        id = attributes.fetch(:id) { raise IdNotProvided.new("id attribute is required") }
        amount = attributes.fetch(:amount) { raise AmountNotProvided.new("amount attribute is required") }

        request(:confirm, transaction_id: id, amount:)[:success]
      end

      def void(id)
        request(:void, transaction_id: id)[:success]
      end

      alias_method :cancel, :void

      def refund(attributes)
        id = attributes.fetch(:id) { raise IdNotProvided.new("id attribute is required") }
        amount = attributes.fetch(:amount) { raise AmountNotProvided.new("amount attribute is required") }

        request(:refund, transaction_id: id, amount:)[:success]
      end

      def post3ds(id, pa_res)
        response = request(:post3ds, transaction_id: id, pa_res: pa_res)
        Transaction.new(response[:model])
      end

      def get(id)
        response = request(:get, transaction_id: id)
        Transaction.new(response[:model])
      end

      def find(invoice_id)
        response = request(:find, invoice_id: invoice_id)
        Transaction.new(response[:model])
      end

      def token_topup(attributes)
        attributes.fetch(:token) { raise TokenNotProvided.new("token attribute is required") }
        attributes.fetch(:amount) { raise AmountNotProvided.new("amount attribute is required") }
        attributes.fetch(:account_id) { raise AccountIdNotProvided.new("account_id attribute is required") }
        attributes.fetch(:currency) { raise CurrencyNotProvided.new("currency attribute is required") }

        response = request("token/topup", attributes)
        Transaction.new(response[:model])
      end

      def cards_topup(attributes)
        attributes.fetch(:card_cryptogram_packet) { raise CardCryptogramPacketNotProvided.new("card_cryptogram_packet attribute is required") }
        attributes.fetch(:amount) { raise AmountNotProvided.new("amount attribute is required") }
        attributes.fetch(:currency) { raise CurrencyNotProvided.new("currency attribute is required") }

        response = request("cards/topup", attributes)
        Transaction.new(response[:model])
      end

      def list(attributes)
        attributes.fetch(:date) { raise DateNotProvided.new("date attribute is required") }

        response = request(:list, attributes)
        Array(response[:model]).map { |model| Transaction.new(model) }
      end

      def tokens_list(attributes)
        attributes.fetch(:page_number) { raise PageNumberNotProvided.new("page_number attribute is required") }

        response = request("tokens/list", attributes)
        Array(response[:model]).map { |model| Token.new(model) }
      end
    end
  end
end
