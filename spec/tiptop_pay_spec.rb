# frozen_string_literal: true

require "spec_helper"

describe TiptopPay do
  describe "#config=" do
    specify { expect { TiptopPay.config = "config" }.to change { TiptopPay.config }.to("config") }
  end

  it "supports global configuration" do
    TiptopPay.config.secret_key = "OLD_KEY"

    TiptopPay.configure do |c|
      c.secret_key = "NEW_KEY"
    end

    expect(TiptopPay.config.secret_key).to eq "NEW_KEY"
    expect(TiptopPay.client.config.secret_key).to eq "NEW_KEY"
  end

  it "supports local configuration" do
    TiptopPay.config.secret_key = "OLD_KEY"

    config = TiptopPay::Config.new do |c|
      c.secret_key = "NEW_KEY"
    end
    client = TiptopPay::Client.new(config)
    webhooks = TiptopPay::Webhooks.new(config)

    expect(TiptopPay.config.secret_key).to eq "OLD_KEY"
    expect(config.secret_key).to eq "NEW_KEY"
    expect(client.config.secret_key).to eq "NEW_KEY"
    expect(webhooks.config.secret_key).to eq "NEW_KEY"
  end
end
