# frozen_string_literal: true

require "spec_helper"

describe TiptopPay::Namespaces::Cards do
  subject { TiptopPay::Namespaces::Cards.new(TiptopPay.client, "/payments") }

  let(:attributes) {
    {
      amount: 10,
      currency: "KZT",
      invoice_id: "1234567",
      ip_address: "123.123.123.123",
      description: "Оплата товаров в example.com",
      account_id: "user_x",
      name: "CARDHOLDER NAME",
      card_cryptogram_packet: "01492500008719030128SMfLeYdKp5dSQVIiO5l6ZCJiPdel4uDjdFTTz1UnXY+3QaZcNOW8lmXg0H670MclS4lI+qLkujKF4pR5Ri+T/E04Ufq3t5ntMUVLuZ998DLm+OVHV7FxIGR7snckpg47A73v7/y88Q5dxxvVZtDVi0qCcJAiZrgKLyLCqypnMfhjsgCEPF6d4OMzkgNQiynZvKysI2q+xc9cL0+CMmQTUPytnxX52k9qLNZ55cnE8kuLvqSK+TOG7Fz03moGcVvbb9XTg1oTDL4pl9rgkG3XvvTJOwol3JDxL1i6x+VpaRxpLJg0Zd9/9xRJOBMGmwAxo8/xyvGuAj85sxLJL6fA==",
      payer: {
        first_name: "Тест",
        last_name: "Тестов",
        middle_name: "Тестович",
        birth: "1955-02-24",
        address: "тестовый проезд дом тест",
        street: "Lenina",
        city: "Almaty",
        country: "KZ",
        phone: "123",
        postcode: "345"
      }
    }
  }

  describe "#charge" do
    context "config.raise_banking_errors = false" do
      before { TiptopPay.config.raise_banking_errors = false }

      context do
        before { stub_api_request("cards/charge/successful").perform }
        specify { expect(subject.charge(attributes)).to be_instance_of(TiptopPay::Transaction) }
        specify { expect(subject.charge(attributes)).not_to be_required_secure3d }
        specify { expect(subject.charge(attributes)).to be_authorized }
        specify { expect(subject.charge(attributes).id).to eq(891510444) }
      end

      context do
        before { stub_api_request("cards/charge/secure3d").perform }
        specify { expect(subject.charge(attributes)).to be_instance_of(TiptopPay::Secure3D) }
        specify { expect(subject.charge(attributes)).to be_required_secure3d }
        specify { expect(subject.charge(attributes).id).to eq(891463508) }
        specify { expect(subject.charge(attributes).transaction_id).to eq(891463508) }
        specify { expect(subject.charge(attributes).pa_req).to eq("+/eyJNZXJjaGFudE5hbWUiOm51bGwsIkZpcnN0U2l4IjoiNDI0MjQyIiwiTGFzdEZvdXIiOiI0MjQyIiwiQW1vdW50IjoxMDAuMCwiQ3VycmVuY3lDb2RlIjoiUlVCIiwiRGF0ZSI6IjIwMjEtMTAtMjVUMDA6MDA6MDArMDM6MDAiLCJDdXN0b21lck5hbWUiOm51bGwsIkN1bHR1cmVOYW1lIjoicnUtUlUifQ==") }
        specify { expect(subject.charge(attributes).acs_url).to eq("https://demo.tiptoppay.kz/acs") }
      end

      context do
        before { stub_api_request("cards/charge/failed").perform }
        specify { expect(subject.charge(attributes)).to be_instance_of(TiptopPay::Transaction) }
        specify { expect(subject.charge(attributes)).not_to be_required_secure3d }
        specify { expect(subject.charge(attributes)).to be_declined }
        specify { expect(subject.charge(attributes).id).to eq(891583633) }
        specify { expect(subject.charge(attributes).reason).to eq("InsufficientFunds") }
      end
    end

    context "config.raise_banking_errors = true" do
      before { TiptopPay.config.raise_banking_errors = true }

      context do
        before { stub_api_request("cards/charge/successful").perform }
        specify { expect { subject.charge(attributes) }.not_to raise_error }
      end

      context do
        before { stub_api_request("cards/charge/secure3d").perform }
        specify { expect { subject.charge(attributes) }.not_to raise_error }
      end

      context do
        before { stub_api_request("cards/charge/failed").perform }
        specify { expect { subject.charge(attributes) }.to raise_error(TiptopPay::Client::GatewayErrors::InsufficientFunds) }
      end
    end
  end

  describe "#auth" do
    context "config.raise_banking_errors = false" do
      before { TiptopPay.config.raise_banking_errors = false }

      context do
        before { stub_api_request("cards/auth/successful").perform }
        specify { expect(subject.auth(attributes)).to be_instance_of(TiptopPay::Transaction) }
        specify { expect(subject.auth(attributes)).not_to be_required_secure3d }
        specify { expect(subject.auth(attributes)).to be_authorized }
        specify { expect(subject.auth(attributes).id).to eq(891510444) }
      end

      context do
        before { stub_api_request("cards/auth/secure3d").perform }
        specify { expect(subject.auth(attributes)).to be_instance_of(TiptopPay::Secure3D) }
        specify { expect(subject.auth(attributes)).to be_required_secure3d }
        specify { expect(subject.auth(attributes).id).to eq(891463508) }
        specify { expect(subject.auth(attributes).transaction_id).to eq(891463508) }
        specify { expect(subject.auth(attributes).pa_req).to eq("+/eyJNZXJjaGFudE5hbWUiOm51bGwsIkZpcnN0U2l4IjoiNDI0MjQyIiwiTGFzdEZvdXIiOiI0MjQyIiwiQW1vdW50IjoxMDAuMCwiQ3VycmVuY3lDb2RlIjoiUlVCIiwiRGF0ZSI6IjIwMjEtMTAtMjVUMDA6MDA6MDArMDM6MDAiLCJDdXN0b21lck5hbWUiOm51bGwsIkN1bHR1cmVOYW1lIjoicnUtUlUifQ==") }
        specify { expect(subject.auth(attributes).acs_url).to eq("https://demo.tiptoppay.kz/acs") }
      end

      context do
        before { stub_api_request("cards/auth/failed").perform }
        specify { expect(subject.auth(attributes)).to be_instance_of(TiptopPay::Transaction) }
        specify { expect(subject.auth(attributes)).not_to be_required_secure3d }
        specify { expect(subject.auth(attributes)).to be_declined }
        specify { expect(subject.auth(attributes).id).to eq(891583633) }
        specify { expect(subject.auth(attributes).reason).to eq("InsufficientFunds") }
      end
    end

    context "config.raise_banking_errors = true" do
      before { TiptopPay.config.raise_banking_errors = true }

      context do
        before { stub_api_request("cards/auth/successful").perform }
        specify { expect { subject.auth(attributes) }.not_to raise_error }
      end

      context do
        before { stub_api_request("cards/auth/secure3d").perform }
        specify { expect { subject.auth(attributes) }.not_to raise_error }
      end

      context do
        before { stub_api_request("cards/auth/failed").perform }
        specify { expect { subject.auth(attributes) }.to raise_error(TiptopPay::Client::GatewayErrors::InsufficientFunds) }
      end
    end
  end

  describe "#post3ds" do
    let(:attributes) { {id: 12345, pa_res: "AQ=="} }

    context "config.raise_banking_errors = false" do
      before { TiptopPay.config.raise_banking_errors = false }

      context do
        before { stub_api_request("cards/post3ds/successful").perform }
        specify { expect(subject.post3ds(attributes)).to be_instance_of(TiptopPay::Transaction) }
        specify { expect(subject.post3ds(attributes)).not_to be_required_secure3d }
        specify { expect(subject.post3ds(attributes)).to be_completed }
        specify { expect(subject.post3ds(attributes).id).to eq(12345) }
      end

      context do
        before { stub_api_request("cards/post3ds/failed").perform }
        specify { expect(subject.post3ds(attributes)).to be_instance_of(TiptopPay::Transaction) }
        specify { expect(subject.post3ds(attributes)).not_to be_required_secure3d }
        specify { expect(subject.post3ds(attributes)).to be_declined }
        specify { expect(subject.post3ds(attributes).id).to eq(12345) }
        specify { expect(subject.post3ds(attributes).reason).to eq("InsufficientFunds") }
      end
    end

    context "config.raise_banking_errors = true" do
      before { TiptopPay.config.raise_banking_errors = true }

      context do
        before { stub_api_request("cards/post3ds/successful").perform }
        specify { expect { subject.post3ds(attributes) }.not_to raise_error }
      end

      context do
        before { stub_api_request("cards/post3ds/failed").perform }
        specify { expect { subject.post3ds(attributes) }.to raise_error(TiptopPay::Client::GatewayErrors::InsufficientFunds) }
      end
    end
  end
end
