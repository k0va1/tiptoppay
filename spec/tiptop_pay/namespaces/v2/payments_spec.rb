# frozen_string_literal: true

require "spec_helper"

describe TiptopPay::Namespaces::V2::Payments do
  subject { TiptopPay::Namespaces::V2::Payments.new(TiptopPay.client) }

  describe "#list" do
    let(:attributes) { {created_date_gte: "2021-03-09T00:00:00+03:00", created_date_lte: "2021-03-10T00:00:00+03:00", page_number: 1} }

    context "successful" do
      before { stub_api_request("v2/payments/list/successful").perform }
      specify { expect(subject.list(attributes).length).to eq(1) }
      specify { expect(subject.list(attributes).first).to be_instance_of(TiptopPay::Transaction) }
    end
  end
end
