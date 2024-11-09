#!/usr/bin/env ruby
# frozen_string_literal: true

require "spec_helper"

describe TiptopPay::Namespaces::Kassa do
  subject { described_class.new(TiptopPay.client) }

  describe "#receipt" do
    let(:attributes) do
      {
        inn: "7708806666",
        type: "Income",
        customer_receipt: {
          items: [
            {
              amount: "13350.00",
              label: "Good Description",
              price: "13350.00",
              quantity: 1.0,
              vat: 0
            }
          ]
        }
      }
    end

    context do
      before { attributes.delete(:inn) }
      specify { expect { subject.receipt(attributes) }.to raise_error(described_class::InnNotProvided) }
    end

    context do
      before { attributes.delete(:type) }
      specify { expect { subject.receipt(attributes) }.to raise_error(described_class::TypeNotProvided) }
    end

    context do
      before { attributes.delete(:customer_receipt) }
      specify { expect { subject.receipt(attributes) }.to raise_error(described_class::CustomerReceiptNotProvided) }
    end
  end

  describe "#receipt_status" do
    let(:attributes) do
      {id: "7708806666"}
    end

    context do
      before { attributes.delete(:id) }
      specify { expect { subject.receipt_status(attributes) }.to raise_error(described_class::IdNotProvided) }
    end
  end

  describe "#fetch_receipt" do
    let(:attributes) do
      {id: "7708806666"}
    end

    context do
      before { attributes.delete(:id) }
      specify { expect { subject.fetch_receipt(attributes) }.to raise_error(described_class::IdNotProvided) }
    end
  end
end
