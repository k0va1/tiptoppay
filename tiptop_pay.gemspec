# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tiptop_pay/version"

Gem::Specification.new do |spec|
  spec.name = "tiptop_pay"
  spec.version = TiptopPay::VERSION
  spec.authors = ["undr", "kirillplatonov", "k0va1"]
  spec.email = ["undr@yandex.ru", "mail@kirillplatonov.com", "al3xander.koval@gmail.com"]
  spec.summary = "TiptopPay ruby client"
  spec.description = "TiptopPay ruby client"
  spec.homepage = "https://github.com/k0va1/tiptoppay"
  spec.license = "MIT"

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "2.12.0"
  spec.add_dependency "multi_json", "~> 1.11"
  spec.add_dependency "hashie", "~> 5.0"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.9"
  spec.add_development_dependency "standardrb"
end
