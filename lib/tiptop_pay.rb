# frozen_string_literal: true

require "date"
require "hashie"
require "faraday"
require "multi_json"
require "tiptop_pay/version"
require "tiptop_pay/config"
require "tiptop_pay/namespaces"
require "tiptop_pay/models"
require "tiptop_pay/client"
require "tiptop_pay/webhooks"

module TiptopPay
  extend self

  def config=(value)
    @config = value
  end

  def config
    @config ||= Config.new
  end

  def configure
    yield config
  end

  def client=(value)
    @client = value
  end

  def client
    @client ||= Client.new
  end

  def webhooks
    @webhooks ||= Webhooks.new
  end
end
