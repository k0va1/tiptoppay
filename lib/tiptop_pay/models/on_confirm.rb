# frozen_string_literal: true

module TiptopPay
  # @see https://developers.tiptoppay.kz/#confirm
  class OnConfirm < Model
    property :id, from: :transaction_id, required: true
    property :amount, transform_with: DecimalTransform, required: true
    property :currency, required: true
    property :payment_amount, required: true
    property :payment_currency, required: true
    property :date_time, transform_with: DateTimeTransform, required: true
    property :card_first_six, required: true
    property :card_last_four, required: true
    property :card_type, required: true
    property :card_exp_date, required: true
    property :test_mode, required: true, transform_with: BooleanTransform
    property :status, required: true
    property :invoice_id
    property :account_id
    property :subscription_id
    property :name
    property :email
    property :ip_address
    property :ip_country
    property :ip_city
    property :ip_region
    property :ip_district
    property :ip_latitude
    property :ip_longitude
    property :issuer
    property :issuer_bank_country
    property :description
    property :auth_code
    property :metadata, from: :data, default: {}
    property :token
    property :payment_method
    property :rrm
  end
end