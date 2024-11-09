# frozen_string_literal: true

module TiptopPay
  # @see https://kassir.tiptoppay.kz/#receipt
  class OnKassaReceipt < Model
    property :id, required: true
    property :document_number, required: true
    property :session_number, required: true
    property :number, required: true
    property :fiscal_sign, required: true
    property :device_number, required: true
    property :reg_number, required: true
    property :fiscal_number, required: true
    property :inn, required: true
    property :type, required: true
    property :ofd, required: true
    property :url, required: true
    property :transaction_id
    property :amount, transform_with: DecimalTransform, required: true
    property :date_time, transform_with: DateTimeTransform
    property :invoice_id
    property :account_id
    property :receipt, required: true
    property :calculation_place
    property :cashier_name
    property :settle_place
  end
end
