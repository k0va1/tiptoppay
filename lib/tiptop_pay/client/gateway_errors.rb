# frozen_string_literal: true

module TiptopPay
  class Client
    class ReasonedGatewayError < StandardError; end

    module GatewayErrors; end

    REASON_CODES = {
      5001 => "ReferToCardIssuer",
      5005 => "DoNotHonor",
      5006 => "Error",
      5012 => "Invalid",
      5013 => "AmountError",
      5030 => "FormatError",
      5031 => "BankNotSupportedBySwitch",
      5034 => "SuspectedFraud",
      5041 => "LostCard",
      5043 => "StolenCard",
      5051 => "InsufficientFunds",
      5054 => "ExpiredCard",
      5057 => "TransactionNotPermitted",
      5065 => "ExceedWithdrawalFrequency",
      5082 => "IncorrectCVV",
      5091 => "Timeout",
      5092 => "CannotReachNetwork",
      5096 => "SystemError",
      5204 => "UnableToProcess",
      5206 => "AuthenticationFailed",
      5207 => "AuthenticationUnavailable",
      5300 => "AntiFraud"
    }

    GATEWAY_ERRORS = REASON_CODES.each_with_object({}) do |error, result|
      status, name = error
      result[status] = GatewayErrors.const_set(name, Class.new(ReasonedGatewayError))
    end
  end
end
