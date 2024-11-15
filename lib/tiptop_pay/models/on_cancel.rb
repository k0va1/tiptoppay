# frozen_string_literal: true

module TiptopPay
  # @see https://developers.tiptoppay.kz/#cancel
  class OnCancel < Model
    property :id, from: :transaction_id, required: true
    property :amount, transform_with: DecimalTransform, required: true
    property :date_time, transform_with: DateTimeTransform, required: true
    property :invoice_id
    property :account_id
    property :email
    property :metadata, from: :data, default: {}
    property :rrn
  end
end
