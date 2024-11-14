# frozen_string_literal: true

module TiptopPay
  module Namespaces
    class Orders < Base
      AmountNotProvided = Class.new(StandardError)
      DescriptionNotProvided = Class.new(StandardError)

      def create(attributes)
        attributes.fetch(:amount) { raise AmountNotProvided.new("amount attribute is required") }
        attributes.fetch(:description) { raise DescriptionNotProvided.new("description attribute is required") }

        response = request(:create, attributes)
        Order.new(response[:model])
      end

      def cancel(order_id)
        request(:cancel, id: order_id)[:success]
      end
    end
  end
end
