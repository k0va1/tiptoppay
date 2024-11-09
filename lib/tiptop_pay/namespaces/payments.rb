# frozen_string_literal: true

module TiptopPay
  module Namespaces
    class Payments < Base
      def cards
        Cards.new(client, resource_path)
      end

      def tokens
        Tokens.new(client, resource_path)
      end

      def confirm(id, amount)
        request(:confirm, transaction_id: id, amount: amount)[:success]
      end

      def void(id)
        request(:void, transaction_id: id)[:success]
      end

      alias_method :cancel, :void

      def refund(id, amount)
        request(:refund, transaction_id: id, amount: amount)[:success]
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
        response = request("token/topup", attributes)
        Transaction.new(response[:model])
      end

      def cards_topup(attributes)
        response = request("cards/topup", attributes)
        Transaction.new(response[:model])
      end

      def list(attributes)
        response = request(:list, attributes)
        Array(response[:model]).map { |model| Transaction.new(model) }
      end

      def tokens_list(attributes)
        response = request("tokens/list", attributes)
        Array(response[:model]).map { |model| Token.new(model) }
      end
    end
  end
end
