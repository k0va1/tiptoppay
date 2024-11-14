# frozen_string_literal: true

module TiptopPay
  module Namespaces
    module V2
      class Payments < Base
        def self.resource_name
          "v2/#{super}"
        end

        CreatedDateGteNotProvided = Class.new(StandardError)
        CreatedDateLteNotProvided = Class.new(StandardError)
        PageNumberNotProvided = Class.new(StandardError)

        def list(attributes)
          attributes.fetch(:created_date_gte) { raise CreatedDateGteNotProvided.new("created_date_gte attribute is required") }
          attributes.fetch(:created_date_lte) { raise CreatedDateLteNotProvided.new("created_date_lte attribute is required") }
          attributes.fetch(:page_number) { raise PageNumberNotProvided.new("page_number attribute is required") }

          response = request(:list, attributes)
          Array(response[:model]).map { |model| Transaction.new(model) }
        end
      end
    end
  end
end
