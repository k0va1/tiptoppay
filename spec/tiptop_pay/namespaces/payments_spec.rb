# frozen_string_literal: true

require "spec_helper"

describe TiptopPay::Namespaces::Payments do
  subject { TiptopPay::Namespaces::Payments.new(TiptopPay.client) }

  describe "#cards" do
    specify { expect(subject.cards).to be_instance_of(TiptopPay::Namespaces::Cards) }
    specify { expect(subject.cards.parent_path).to eq("payments") }
  end

  describe "#tokens" do
    specify { expect(subject.tokens).to be_instance_of(TiptopPay::Namespaces::Tokens) }
    specify { expect(subject.tokens.parent_path).to eq("payments") }
  end

  describe "#confirm" do
    context do
      before { stub_api_request("payments/confirm/successful").perform }
      specify { expect(subject.confirm(id: 12345, amount: 120)).to be_truthy }
    end

    context do
      before { stub_api_request("payments/confirm/failed").perform }
      specify { expect(subject.confirm(id: 12345, amount: 120)).to be_falsy }
    end

    context do
      before { stub_api_request("payments/confirm/failed_with_message").perform }
      specify { expect { subject.confirm(id: 12345, amount: 120) }.to raise_error(TiptopPay::Client::GatewayError, "Error message") }
    end
  end

  describe "#void" do
    context do
      before { stub_api_request("payments/void/successful").perform }
      specify { expect(subject.void(12345)).to be_truthy }
    end

    context do
      before { stub_api_request("payments/void/failed").perform }
      specify { expect(subject.void(12345)).to be_falsy }
    end

    context do
      before { stub_api_request("payments/void/failed_with_message").perform }
      specify { expect { subject.void(12345) }.to raise_error(TiptopPay::Client::GatewayError, "Error message") }
    end
  end

  describe "#refund" do
    context do
      before { stub_api_request("payments/refund/successful").perform }
      specify { expect(subject.refund(id: 12345, amount: 120)).to be_truthy }
    end

    context do
      before { stub_api_request("payments/refund/failed").perform }
      specify { expect(subject.refund(id: 12345, amount: 120)).to be_falsy }
    end

    context do
      before { stub_api_request("payments/refund/failed_with_message").perform }
      specify { expect { subject.refund(id: 12345, amount: 120) }.to raise_error(TiptopPay::Client::GatewayError, "Error message") }
    end
  end

  describe "#get" do
    let(:transaction_id) { 12345 }

    context "config.raise_banking_errors = false" do
      before { TiptopPay.config.raise_banking_errors = false }

      context "transaction not found" do
        before { stub_api_request("payments/get/failed_with_message").perform }
        specify { expect { subject.get(transaction_id) }.to raise_error(TiptopPay::Client::GatewayError, "Not found") }
      end

      context "transaction is failed" do
        before { stub_api_request("payments/get/failed").perform }
        specify { expect(subject.get(transaction_id)).to be_instance_of(TiptopPay::Transaction) }
        specify { expect(subject.get(transaction_id)).not_to be_required_secure3d }
        specify { expect(subject.get(transaction_id)).to be_declined }
        specify { expect(subject.get(transaction_id).id).to eq(transaction_id) }
        specify { expect(subject.get(transaction_id).reason).to eq("InsufficientFunds") }
      end

      context "transaction is successful" do
        before { stub_api_request("payments/get/successful").perform }
        specify { expect(subject.get(transaction_id)).to be_instance_of(TiptopPay::Transaction) }
        specify { expect(subject.get(transaction_id)).not_to be_required_secure3d }
        specify { expect(subject.get(transaction_id)).to be_completed }
        specify { expect(subject.get(transaction_id).id).to eq(transaction_id) }
        specify { expect(subject.get(transaction_id).reason).to eq("Approved") }
      end

      context "transaction is refunded" do
        before { stub_api_request("payments/get/refunded").perform }
        specify { expect(subject.get(transaction_id)).to be_completed }
        specify { expect(subject.get(transaction_id)).to be_refunded }
      end
    end

    context "config.raise_banking_errors = true" do
      before { TiptopPay.config.raise_banking_errors = true }

      context "transaction not found" do
        before { stub_api_request("payments/get/failed_with_message").perform }
        specify { expect { subject.get(transaction_id) }.to raise_error(TiptopPay::Client::GatewayError, "Not found") }
      end

      context "transaction is failed" do
        before { stub_api_request("payments/get/failed").perform }
        specify { expect { subject.get(transaction_id) }.to raise_error(TiptopPay::Client::GatewayErrors::InsufficientFunds) }
      end

      context "transaction is successful" do
        before { stub_api_request("payments/get/successful").perform }
        specify { expect { subject.get(transaction_id) }.to_not raise_error }
        specify { expect(subject.get(transaction_id)).to be_instance_of(TiptopPay::Transaction) }
        specify { expect(subject.get(transaction_id)).not_to be_required_secure3d }
        specify { expect(subject.get(transaction_id)).to be_completed }
        specify { expect(subject.get(transaction_id).id).to eq(transaction_id) }
        specify { expect(subject.get(transaction_id).reason).to eq("Approved") }
      end
    end
  end

  describe "#find" do
    let(:invoice_id) { "1234567" }

    context "config.raise_banking_errors = false" do
      before { TiptopPay.config.raise_banking_errors = false }

      context "payment is not found" do
        before { stub_api_request("payments/find/failed_with_message").perform }
        specify { expect { subject.find(invoice_id) }.to raise_error(TiptopPay::Client::GatewayError, "Not found") }
      end

      context "payment is failed" do
        before { stub_api_request("payments/find/failed").perform }
        specify { expect(subject.find(invoice_id)).to be_instance_of(TiptopPay::Transaction) }
        specify { expect(subject.find(invoice_id)).not_to be_required_secure3d }
        specify { expect(subject.find(invoice_id)).to be_declined }
        specify { expect(subject.find(invoice_id).id).to eq(12345) }
        specify { expect(subject.find(invoice_id).invoice_id).to eq(invoice_id) }
        specify { expect(subject.find(invoice_id).reason).to eq("InsufficientFunds") }
      end

      context "transaction is successful" do
        before { stub_api_request("payments/find/successful").perform }
        specify { expect(subject.find(invoice_id)).to be_instance_of(TiptopPay::Transaction) }
        specify { expect(subject.find(invoice_id)).not_to be_required_secure3d }
        specify { expect(subject.find(invoice_id)).to be_completed }
        specify { expect(subject.find(invoice_id).id).to eq(12345) }
        specify { expect(subject.find(invoice_id).invoice_id).to eq(invoice_id) }
        specify { expect(subject.find(invoice_id).reason).to eq("Approved") }
      end
    end

    context "config.raise_banking_errors = true" do
      before { TiptopPay.config.raise_banking_errors = true }

      context "payment is not found" do
        before { stub_api_request("payments/find/failed_with_message").perform }
        specify { expect { subject.find(invoice_id) }.to raise_error(TiptopPay::Client::GatewayError, "Not found") }
      end

      context "payment is failed" do
        before { stub_api_request("payments/find/failed").perform }
        specify { expect { subject.find(invoice_id) }.to raise_error(TiptopPay::Client::GatewayErrors::InsufficientFunds) }
      end

      context "transaction is successful" do
        before { stub_api_request("payments/find/successful").perform }
        specify { expect(subject.find(invoice_id)).to be_instance_of(TiptopPay::Transaction) }
        specify { expect(subject.find(invoice_id)).not_to be_required_secure3d }
        specify { expect(subject.find(invoice_id)).to be_completed }
        specify { expect(subject.find(invoice_id).id).to eq(12345) }
        specify { expect(subject.find(invoice_id).invoice_id).to eq(invoice_id) }
        specify { expect(subject.find(invoice_id).reason).to eq("Approved") }
      end
    end
  end

  describe "#list" do
    context "successful" do
      before { stub_api_request("payments/list/successful").perform }
      specify { expect(subject.list(date: "2014-08-09").length).to eq(1) }
      specify { expect(subject.list(date: "2014-08-09").first).to be_instance_of(TiptopPay::Transaction) }
    end
  end
end
