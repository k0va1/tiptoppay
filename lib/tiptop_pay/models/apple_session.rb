# frozen_string_literal: true

module TiptopPay
  # @see https://developers.tiptoppay.kz/#zapusk-sessii-dlya-oplaty-cherez-apple-pay
  class AppleSession < Model
    property :epoch_timestamp
    property :expires_at
    property :merchant_session_identifier
    property :nonce
    property :merchant_identifier
    property :domain_name
    property :display_name
    property :signature
  end
end
