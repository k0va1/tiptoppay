# TiptopPay

[TiptopPay](https://developers.tiptoppay.kz/#api) ruby client

## Installation

Add this line to your application's Gemfile:

```ruby
gem "tiptop_pay"
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install tiptop_pay
```

## Usage

### Configuration

#### Global configuration

```ruby
TiptopPay.configure do |c|
  c.host = "http://localhost:3000"    # By default, it is https://api.tiptoppay.kz
  c.public_key = ""                   # You can get your public and secret key from the TiptopPay dashboard https://merchant.tiptoppay.kz/sites
  c.secret_key = ""
  c.log = false                       # By default. it is true
  c.logger = Logger.new("/dev/null")  # By default, it writes logs to stdout
  c.raise_banking_errors = true       # By default, it is not raising banking errors
end

# API client
TiptopPay.client.payments.cards.charge(...)

# Webhooks
TiptopPay.webhooks.on_pay(...)
```

#### Local configuration

```ruby
config = TiptopPay::Config.new do |c|
  # ...
end

# API client
client = TiptopPay::Client.new(config)
client.payments.cards.charge(...)

# Webhooks
webhooks = TiptopPay::Webhooks.new(config)
webhooks.on_pay(...)
```

### API reference

1. [Test method](#test-method)

#### Payments

1. [Cryptogram-based payments](#cryptogram-based-payments)
2. [3-D Secure authentication](#3-d-secure-authentication)
3. [Token-based payments](#token-based-payments)
4. [Payment confirmation](#payment-confirmation)
5. [Payment cancelation](#payment-cancelation)
6. [Payment refund](#payment-refund)
7. [Card topup](#card-topup)
8. [Token topup](#token-topup)
9. [Get transaction data](#get-transaction-data)
10. [Get transaction status](#get-transaction-status)
11. [Get transactions history](#get-transactions-history)
12. [Get tokens list](#get-tokens-list)

#### Subscriptions

1. [Create subscription](#create-subscription)
2. [Get subscription data](#get-subscription-data)
3. [Get subscription by account](#get-subscription-by-account)
4. [Update subscription](#update-subscription)
5. [Cancel subscription](#cancel-subscription)

#### Orders

1. [Create order](#create-order)
2. [Cancel order](#cancel-order)

#### Apple Pay

1. [Start Apple Pay session](#start-apple-pay-session)

#### Kassa

1. [Create receipt](#create-receipt)
2. [Get receipt status](#get-receipt-status)
3. [Get receipt data](#get-receipt-data)

#### Webhooks

1. [On check](#on-check)
2. [On pay](#on-pay)
3. [On fail](#on-fail)
4. [On confirm](#on-confirm)
5. [On refund](#on-refund)
6. [On recurrent](#on-recurrent)
7. [On cancel](#on-cancel)

### API methods

#### [Test method](#test-method)

[Reference](https://developers.tiptoppay.kz/#testovyy-metod)

```ruby
TiptopPay.client.ping
# => true
```

#### Payments

#### [Cryptogram-based payments](#cryptogram-based-payments)

[Reference](https://developers.tiptoppay.kz/#oplata-po-kriptogramme)

```ruby
# Signle step payment
transaction = TiptopPay.client.payments.cards.charge(
  amount: 120,
  currency: "KZT",
  ip_address: "35.48.12.5",
  card_cryptogram_packet: "eyJUeXBlIjoiQ2xvdWRDYXJkIiwibWV0YURhdG" # https://developers.tiptoppay.kz/#skript-checkout
)
transaction.class
# => TiptopPay::Transaction
transaction.token
# => "a4e67841-abb0-42de-a364-d1d8f9f4b3c0"

# Two step payment
transaction = TiptopPay.client.payments.cards.auth(
  amount: 120,
  currency: "KZT",
  ip_address:  "35.48.12.5",
  card_cryptogram_packet: "eyJUeXBlIjoiQ2xvdWRDYXJkIiwibWV0YURhdG" # https://developers.tiptoppay.kz/#skript-checkout
)
transaction.class
# => TiptopPay::Transaction
transaction.token
# => "a4e67841-abb0-42de-a364-d1d8f9f4b3c0"
```

#### [3-D Secure authentication](#3-d-secure-authentication)

[Reference](https://developers.tiptoppay.kz/#obrabotka-3-d-secure)

```ruby
transaction = TiptopPay.client.payments.cards.post3ds(
  id: 12345,
  pa_res: "eJxVUd1OAzEMvXe5wQY7"
)
transaction.class
# => TiptopPay::Transaction
transaction.token
# => "a4e67841-abb0-42de-a364-d1d8f9f4b3c0"
```

#### [Token-based payments](#token-based-payments)

[Reference](https://developers.tiptoppay.kz/#oplata-po-tokenu-rekarring)

```ruby
# Signle step payment
transaction = TiptopPay.client.payments.tokens.charge(
  amount: 10,
  account_id: "user_x",
  token: "a4e67841-abb0-42de-a364-d1d8f9f4b3c0"
)

# Two step payment
transaction = TiptopPay.client.payments.tokens.auth(
  amount: 10,
  account_id: "user_x",
  token: "a4e67841-abb0-42de-a364-d1d8f9f4b3c0"
)
```

#### [Payment confirmation](#payment-confirmation)

[Reference](https://developers.tiptoppay.kz/#podtverzhdenie-oplaty)

```ruby
transaction = TiptopPay.client.payments.confirm(
  id: 12345,
  amount: 10
)
```

#### [Payment cancelation](#payment-cancelation)

[Reference](https://developers.tiptoppay.kz/#otmena-oplaty)

```ruby
TiptopPay.client.payments.cancel(12345)
```

#### [Payment refund](#payment-refund)

[Reference](https://developers.tiptoppay.kz/#vozvrat-deneg)

```ruby
TiptopPay.client.payments.refund(
  id: 12345,
  amount: 10
)
```

#### [Card topup](#card-topup)

[Reference](https://developers.tiptoppay.kz/#vyplata-po-kriptogramme)

```ruby
TipTopPay.client.payments.cards.topup(
  card_cryptogram_packet: "eyJUeXBlIjoiQ2xvdWRDYXJkIiwibWV0YURhdG",
  amount: 10,
  currency: "KZT"
)
```

#### [Token topup](#token-topup)

[Reference](https://developers.tiptoppay.kz/#vyplata-po-tokenu)

```ruby
TipTopPay.client.payments.tokens.topup(
  account_id: "user_x",
  token: "a4e67841-abb0-42de-a364-d1d8f9f4b3c0",
  amount: 10,
  currency: "KZT"
)
```

#### [Get transaction data](#get-transaction-data)

[Reference](https://developers.tiptoppay.kz/#prosmotr-tranzaktsii)

```ruby
TiptopPay.client.payments.get(12345)
```

#### [Get transaction status](#get-transaction-status)

[Reference](https://developers.tiptoppay.kz/#proverka-statusa-platezha)

```ruby
# V1
TiptopPay.client.payments.find(12345)

# V2
TiptopPay.client.v2_payments.find(12345)
```

#### [Get transactions history](#get-transactions-history)

[V1 Reference](https://developers.tiptoppay.kz/#vygruzka-spiska-tranzaktsiy)
[V2 Reference](https://developers.tiptoppay.kz/#vygruzka-spiska-tranzaktsiy-za-proizvolnyy-period)

```ruby
# V1
TiptopPay.client.payments.list(date: "2024-01-01")

# V2
TiptopPay.client.v2_payments.list(
  created_date_gte: "2024-01-01",
  created_date_lte: "2024-01-02",
  page_number: 1
)
```

#### [Get tokens list](#get-tokens-list)

[Reference](https://developers.tiptoppay.kz/#vygruzka-tokenov)

```ruby
TiptopPay.client.tokens.list(page_number: 1)
```

#### Subscriptions

#### [Create subscription](#create-subscription)

[Reference](https://developers.tiptoppay.kz/#sozdanie-podpiski-na-rekurrentnye-platezhi)

```ruby
TiptopPay.client.subscriptions.create(
  token: "477BBA133C182267F",
  account_id: "user@example.com",
  description: "Monthly subscription",
  email: "user@example.com",
  amount: 100,
  currency: "KZT",
  require_confirmation: false,
  start_date: "2024-08-09T11:49:41",
  interval: "Month",
  period: 1,
  max_periods: 12
)
```

#### [Get subscription data](#get-subscription-data)

[Reference](https://developers.tiptoppay.kz/#zapros-informatsii-o-podpiske)

```ruby
TiptopPay.client.subscriptions.get("sc_8cf8a9338fb8ebf7202b08d09c938")
```

#### [Get subscription by account](#get-subscription-by-account)

[Reference](https://developers.tiptoppay.kz/#poisk-podpisok)

```ruby
TiptopPay.client.subscriptions.find_all("user@example.com")
```

#### [Update subscription](#update-subscription)

[Reference](https://developers.tiptoppay.kz/#izmenenie-podpiski-na-rekurrentnye-platezhi)

```ruby
TiptopPay.client.subscriptions.update(
  id: "sc_8cf8a9338fb8ebf7202b08d09c938",
  description: "update subscription",
  amount: 150
)
```

#### [Cancel subscription](#cancel-subscription)

[Reference](https://developers.tiptoppay.kz/#otmena-podpiski-na-rekurrentnye-platezhi)

```ruby
TiptopPay.client.subscriptions.cancel("sc_8cf8a9338fb8ebf7202b08d09c938")
```

#### Orders

#### [Create order](#create-order)

[Reference](https://developers.tiptoppay.kz/#otmena-sozdannogo-scheta)

```ruby
TiptopPay.client.orders.create(
  amount: 100,
  currency: "KZT",
  description: "Order description",
  email: "user@example.com"
)
```

#### [Cancel order](#cancel-order)

[Reference](https://developers.tiptoppay.kz/#otmena-sozdannogo-scheta)

```ruby
TiptopPay.client.orders.cancel("f2K8LV6reGE9WBFn")
```

#### Apple Pay

[Start Apple Pay session](https://developers.tiptoppay.kz/#zapusk-sessii-dlya-oplaty-cherez-apple-pay)

```ruby
TiptopPay.client.apple_pay.start_session(
  validation_url: "https://apple-pay-gateway.apple.com/paymentservices/startSession"
)
```

#### Kassa

#### [Create receipt](#create-receipt)

[Reference](https://kassir.tiptoppay.kz/#formirovanie-kassovogo-cheka)

```ruby
TiptopPay.client.kassa.receipt(
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
)
```

#### [Get receipt status](#get-receipt-status)

[Reference](https://kassir.tiptoppay.kz/#zapros-statusa-cheka)

```ruby
TiptopPay.client.kassa.receipt_status("4c335bb5ee56455f916db6e95c0d196e")
```

#### [Get receipt data](#get-receipt-data)

[Reference](https://kassir.tiptoppay.kz/#poluchenie-dannyh-cheka)

```ruby
TiptopPay.client.kassa.fetch_receipt("4c335bb5ee56455f916db6e95c0d196e")
```

#### Webhooks

#### [On check](#on-check)

[Reference](https://developers.tiptoppay.kz/#check)

```ruby
event = TiptopPay.webhooks.on_pay(payload)
```

#### [On pay](#on-pay)

[Reference](https://developers.tiptoppay.kz/#pay)

```ruby
event = TiptopPay.webhooks.on_pay(payload)
```

#### [On fail](#on-fail)

[Reference](https://developers.tiptoppay.kz/#fail)

```ruby
event = TiptopPay.webhooks.on_fail(payload)
```

#### [On confirm](#on-confirm)

[Reference](https://developers.tiptoppay.kz/#confirm)

```ruby
event = TiptopPay.webhooks.on_confirm(payload)
```

#### [On refund](#on-refund)

[Reference](https://developers.tiptoppay.kz/#refund)

```ruby
event = TiptopPay.webhooks.on_refund(payload)
```

#### [On recurrent](#on-recurrent)

[Reference](https://developers.tiptoppay.kz/#recurrent)

```ruby
event = TiptopPay.webhooks.on_recurrent(payload)
```

#### [On cancel](#on-cancel)

[Reference](https://developers.tiptoppay.kz/#cancel)

```ruby
event = TiptopPay.webhooks.on_cancel(payload)
```

#### Rails integration

```ruby
# config/routes.rb
Rails.application.routes.draw do
  # ...
  resources :webhooks, only: [] do
    collection do
      post :pay
      post :check
      post :fail
      post :confirm
      post :refund
      post :receipt
      post :recurrent
    end
  end
end

# app/controllers/webhooks_controller.rb
class WebhooksController < ApplicationController
  rescue_from TiptopPay::Webhooks::HMACError, :handle_hmac_error
  before_action -> { TiptopPay.webhooks.validate_data!(payload, hmac_token) }
  protect_from_forgery with: :null_session


  def pay
    event = TiptopPay.webhooks.on_pay(payload)
    # ...
    render json: { code: 0 }, status: :ok
  end

  def check
    event = TiptopPay.webhooks.on_check(payload)
    # ...
    render json: { code: 0 }, status: :ok
  end

  def fail
    event = TiptopPay.webhooks.on_fail(payload)
    # ...
    render json: { code: 0 }, status: :ok
  end

  def confirm
    event = TiptopPay.webhooks.on_confirm(payload)
    # ...
    render json: { code: 0 }, status: :ok
  end

  def refund
    event = TiptopPay.webhooks.on_refund(payload)
    # ...
    render json: { code: 0 }, status: :ok
  end

  def receipt
    event = TiptopPay.webhooks.on_kassa_receipt(payload)
    # ...
    render json: { code: 0 }, status: :ok
  end

  def recurrent
    event = TiptopPay.webhooks.on_recurrent(payload)
    # ...
    render json: { code: 0 }, status: :ok
  end

  def payload
    params.permit!.to_h
  end
end
```

## Contributing

1. Fork it ( https://github.com/k0va1/tiptoppay/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
