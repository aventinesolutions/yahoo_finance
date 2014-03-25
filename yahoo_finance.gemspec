# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yahoo_finance/version'

Gem::Specification.new do |spec|
  spec.name          = "yahoo_finance"
  spec.version       = YahooFinance::VERSION
  spec.authors       = ["Takis Mercouris"]
  spec.email         = ["tm@polymechanus.com"]
  spec.description   = %q{Library to parse various pages in yahoo finance}
  spec.summary       = %q{Library to parse various pages in yahoo finance}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "nas-yahoo_stock", "~> 1.0.8"
  spec.add_dependency "nokogiri", "~> 1.6.1"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14.1"
end
