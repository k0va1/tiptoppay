#!/usr/bin/env ruby
# frozen_string_literal: true

require "spec_helper"

describe TiptopPay::Namespaces::ApplePay do
  subject { described_class.new(TiptopPay.client) }

  describe "#receipt" do
    let(:attributes) do
      {
        validation_url: ""
      }
    end

    context do
      before { attributes.delete(:validation_url) }
      specify { expect { subject.start_session(attributes) }.to raise_error(described_class::ValidationUrlMissing) }
    end
  end
end
