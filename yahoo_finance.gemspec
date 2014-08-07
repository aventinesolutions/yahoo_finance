# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yahoo_finance/version'

Gem::Specification.new do |spec|
  spec.name          = "yahoo_finance_stock"
  spec.version       = YahooFinance::VERSION
  spec.authors       = ["Takis Mercouris"]
  spec.email         = ["tm@polymechanus.com"]
  spec.description   = %q{Unified library to stock quotes and various pages in yahoo finance, including key statistics, company events, and analyst opinion}
  spec.summary       = %q{Fetch stock information from yahoo finance API and HTML pages}
  spec.homepage      = "http://polymechanus.com/yahoo_finance-ruby-gem-tutorial/"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "nas-yahoo_stock", "~> 1.0.8", ">= 1.0.8"
  spec.add_runtime_dependency "nokogiri", "~> 1.6.1", ">= 1.6.1"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 0"
  spec.add_development_dependency "rspec", "~> 2.14.1", '>= 2.14.1'
end
