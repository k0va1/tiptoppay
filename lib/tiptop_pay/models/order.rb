# frozen_string_literal: true

module TiptopPay
  class Order < Model
    property :id, required: true
    property :number, required: true
    property :amount, transform_with: DecimalTransform, required: true
    property :currency, required: true
    property :currency_code, required: true
    property :email
    property :phone
    property :description, required: true
    property :require_confirmation, transform_with: BooleanTransform, required: true
    property :url, required: true
    property :culture_name
    property :created_at, from: :created_date_iso, transform_with: DateTimeTransform
    property :payment_at, from: :payment_date_iso, transform_with: DateTimeTransform
    property :status
    property :status_code
    property :internal_id
  end
end
