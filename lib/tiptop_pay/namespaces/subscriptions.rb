# frozen_string_literal: true

module TiptopPay
  module Namespaces
    class Subscriptions < Base
      TokenNotProvided = Class.new(StandardError)
      AccountIdNotProvided = Class.new(StandardError)
      DescriptionNotProvided = Class.new(StandardError)
      AmountNotProvided = Class.new(StandardError)
      CurrencyNotProvided = Class.new(StandardError)
      RequireConfirmationNotProvided = Class.new(StandardError)
      StartDateNotProvided = Class.new(StandardError)
      IntervalNotProvided = Class.new(StandardError)
      PeriodNotProvided = Class.new(StandardError)

      def find(id)
        response = request(:get, id: id)
        Subscription.new(response[:model])
      end

      def find_all(account_id)
        response = request(:find, account_id: account_id)
        Array(response[:model]).map { |item| Subscription.new(item) }
      end

      def create(attributes)
        attributes.fetch(:token) { raise TokenNotProvided.new("token attribute is required") }
        attributes.fetch(:account_id) { raise AccountIdNotProvided.new("account_id attribute is required") }
        attributes.fetch(:description) { raise DescriptionNotProvided.new("description attribute is required") }
        attributes.fetch(:amount) { raise AmountNotProvided.new("amount attribute is required") }
        attributes.fetch(:currency) { raise CurrencyNotProvided.new("currency attribute is required") }
        attributes.fetch(:require_confirmation) { raise RequireConfirmationNotProvided.new("require_confirmation attribute is required") }
        attributes.fetch(:start_date) { raise StartDateNotProvided.new("start_date attribute is required") }
        attributes.fetch(:interval) { raise IntervalNotProvided.new("interval attribute is required") }
        attributes.fetch(:period) { raise PeriodNotProvided.new("period attribute is required") }

        response = request(:create, attributes)
        Subscription.new(response[:model])
      end

      def update(id, attributes)
        response = request(:update, attributes.merge(id: id))
        Subscription.new(response[:model])
      end

      def cancel(id)
        request(:cancel, id: id)[:success]
      end
    end
  end
end
