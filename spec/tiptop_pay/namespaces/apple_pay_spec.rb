#!/usr/bin/env ruby
# frozen_string_literal: true

require "spec_helper"

describe TiptopPay::Namespaces::ApplePay do
  subject { described_class.new(TiptopPay.client) }

  describe "#receipt" do
    let(:attributes) do
      {
        validation_url: "https://apple-pay-gateway.apple.com/paymentservices/startSession"
      }
    end

    context "successful" do
      before { stub_api_request("apple_pay/start_session/successful").perform }

      specify { expect(subject.start_session(attributes)).to be_instance_of(TiptopPay::AppleSession) }
      specify { expect(subject.start_session(attributes).epoch_timestamp).to eq(1545111111153) }
      specify { expect(subject.start_session(attributes).expires_at).to eq(1545111111153) }
      specify { expect(subject.start_session(attributes).merchant_identifier).to eq("41B8000198128F7CC4295E03092BE5E287738FD77EC3238789846AC8EF73FCD8") }
    end

    context do
      before { attributes.delete(:validation_url) }
      specify { expect { subject.start_session(attributes) }.to raise_error(described_class::ValidationUrlNotProvided) }
    end
  end
end
