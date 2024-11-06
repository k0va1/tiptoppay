# frozen_string_literal: true

require "spec_helper"

describe TiptopPay::Client::Serializer::MultiJson do
  let(:encoded_data) { '{"Model":{"Id":123,"CurrencyCode":"RUB","Amount":120},"Success":true}' }
  let(:decoded_data) { {model: {id: 123, currency_code: "RUB", amount: 120}, success: true} }

  subject { TiptopPay::Client::Serializer::MultiJson.new(TiptopPay.config) }

  describe "#load" do
    specify { expect(subject.load(encoded_data)).to eq(decoded_data) }
  end

  describe "#dump" do
    specify { expect(subject.dump(decoded_data)).to eq(encoded_data) }
  end
end
