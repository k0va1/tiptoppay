# frozen_string_literal: true

require "spec_helper"

describe TiptopPay::Client::Response do
  let(:status) { 200 }
  let(:body) { '{"Model":{"Id":123,"CurrencyCode":"RUB","Amount":120},"Success":true}'.dup.force_encoding("CP1251").freeze }
  let(:headers) { {"content-type" => "application/json"} }

  subject { TiptopPay::Client::Response.new(status, body, headers) }

  describe "#body" do
    specify { expect(subject.body).to eq(model: {id: 123, currency_code: "RUB", amount: 120}, success: true) }

    context "wnen content type does not match /json/" do
      let(:headers) { {"content-type" => "text/plain"} }
      specify { expect(subject.body).to eq(body) }
      specify { expect(subject.body.encoding.name).to eq("UTF-8") }
    end
  end

  describe "#origin_body" do
    specify { expect(subject.origin_body).to eq(body) }

    context "wnen content type does not match /json/" do
      let(:headers) { {"content-type" => "text/plain"} }
      specify { expect(subject.origin_body).to eq(body) }
    end
  end

  describe "#headers" do
    specify { expect(subject.headers).to eq(headers) }
  end

  describe "#status" do
    specify { expect(subject.status).to eq(status) }
  end
end
