# frozen_string_literal: true

module TiptopPay
  module Namespaces
    class Cards < Base
      AmountNotProvided = Class.new(StandardError)
      IpNotProvided = Class.new(StandardError)
      CardCryptogramPacketNotProvided = Class.new(StandardError)
      TransactionIdNotProvided = Class.new(StandardError)
      PaResNotProvided = Class.new(StandardError)

      def charge(attributes)
        attributes.fetch(:amount) { raise AmountNotProvided.new("amount attribute is required") }
        attributes.fetch(:ip_address) { raise IpNotProvided.new("ip_address attribute is required") }
        attributes.fetch(:card_cryptogram_packet) { raise CardCryptogramPacketNotProvided.new("card_cryptogram_packet attribute is required") }

        response = request(:charge, attributes)
        instantiate(response[:model])
      end

      def auth(attributes)
        attributes.fetch(:amount) { raise AmountNotProvided.new("amount attribute is required") }
        attributes.fetch(:ip_address) { raise IpNotProvided.new("ip_address attribute is required") }
        attributes.fetch(:card_cryptogram_packet) { raise CardCryptogramPacketNotProvided.new("card_cryptogram_packet attribute is required") }

        response = request(:auth, attributes)
        instantiate(response[:model])
      end

      def post3ds(attributes)
        id = attributes.fetch(:id) { raise TransactionIdNotProvided.new("id attribute is required") }
        pa_res = attributes.fetch(:pa_res) { raise PaResNotProvided.new("pa_res attribute is required") }

        response = request(:post3ds, transaction_id: id, pa_res: pa_res)
        instantiate(response[:model])
      end

      private

      def instantiate(model)
        if model[:pa_req]
          Secure3D.new(model)
        else
          Transaction.new(model)
        end
      end
    end
  end
end
