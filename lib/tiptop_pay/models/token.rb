# frozen_string_literal: true

module TiptopPay
  class Token < Model
    property :token
    property :account_id
    property :card_mask
    property :expiration_date_month
    property :expiration_date_year
  end
end
