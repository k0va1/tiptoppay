# frozen_string_literal: true

require "spec_helper"

class TestNamespace < TiptopPay::Namespaces::Base
end

describe TiptopPay::Namespaces::Base do
  let(:headers) { {"Content-Type" => "application/json"} }
  let(:successful_body) { '{"Model":{},"Success":true}' }
  let(:failed_body) { '{"Success":false,"Message":"Error message"}' }
  let(:failed_transaction_body) { '{"Model":{"ReasonCode":5041,"CardHolderMessage":"Contact your bank"},"Success":false}' }
  let(:request_body) { '{"Amount":120,"CurrencyCode":"RUB"}' }
  let(:request_params) { {amount: 120, currency_code: "RUB"} }

  subject { TestNamespace.new(TiptopPay.client) }

  def stub_api(path, body = "")
    url = "http://localhost:9292#{path}"
    stub_request(:post, url).with(body: body, headers: headers, basic_auth: ["user", "pass"])
  end

  describe "#request" do
    context do
      before { stub_api("/testnamespace", request_body).to_return(body: successful_body, headers: headers) }
      specify { expect(subject.request(nil, request_params)) }
    end

    context "with path" do
      before { stub_api("/testnamespace/path", request_body).to_return(body: successful_body, headers: headers) }

      specify { expect(subject.request(:path, request_params)) }
    end

    context "with path and parent path" do
      subject { TestNamespace.new(TiptopPay.client, "parent") }

      before { stub_api("/parent/testnamespace/path", request_body).to_return(body: successful_body, headers: headers) }

      specify { expect(subject.request(:path, request_params)) }
    end

    context "when status is greater than 300" do
      before { stub_api("/testnamespace/path", request_body).to_return(status: 404, headers: headers) }

      specify { expect { subject.request(:path, request_params) }.to raise_error(TiptopPay::Client::Errors::NotFound) }
    end

    context "when failed request" do
      before { stub_api("/testnamespace/path", request_body).to_return(body: failed_body, headers: headers) }

      context "config.raise_banking_errors = true" do
        before { TiptopPay.config.raise_banking_errors = true }
        specify { expect { subject.request(:path, request_params) }.to raise_error(TiptopPay::Client::GatewayError, "Error message") }
      end

      context "config.raise_banking_errors = false" do
        before { TiptopPay.config.raise_banking_errors = false }
        specify { expect { subject.request(:path, request_params) }.to raise_error(TiptopPay::Client::GatewayError, "Error message") }
      end
    end

    context "when failed transaction" do
      before { stub_api("/testnamespace/path", request_body).to_return(body: failed_transaction_body, headers: headers) }

      context "config.raise_banking_errors = true" do
        before { TiptopPay.config.raise_banking_errors = true }
        specify do
          subject.request(:path, request_params)
        rescue TiptopPay::Client::GatewayErrors::LostCard => err
          expect(err).to be_a TiptopPay::Client::ReasonedGatewayError
        end
      end

      context "config.raise_banking_errors = false" do
        before { TiptopPay.config.raise_banking_errors = false }
        specify { expect { subject.request(:path, request_params) }.not_to raise_error }
      end
    end
  end
end
