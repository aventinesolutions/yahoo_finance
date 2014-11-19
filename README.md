# YahooFinance library

YahooFinance lib is a gem that fetches stock quotes, key statistics, company profile, company events, and analyst opinion from Yahoo (TM) API and financial HTML pages. Additionally, it has interfaces for historical data, and financial statements. The loading of stock quotes uses the excellent nas/yahoo_stock gem. This gem provides a 'unified' attribute based interface, and abstracts the source of the information, i.e. the user only needs to specify an attribute without the need to specify the page source of the attribute. This gem leverages to the highest extend possible the YahooStock (yahoo_stock_nas) gem for all the attributes provided by that gem, and fails over to HTML scraping when the data is unavailable there. Naturally, this has an implication on performance; YahooStock queries bundle 50 stocks in each query, whereas HTML scraping happens one page per stock at a time.

#####This gem is currently still in development. HTML scraping now supports many attributes from Key Statistics, supports earnings announcements from the Company Events page, and most attributes from Analyst Opinion -- additional pages will be added as I find time.

#####Caveat: HTML parsing is susceptible to HTML encoding of Yahoo Finance pages; when these pages change, parsing will break. Core Yahoo API attributes from YahooStock will entirely depend on YahooStock continuing to support the Yahoo APIs.

#####Use the code entirely at your own risk, and subject to copyright & trademark restrictions on Yahoo Finance(TM). I am quite sure that are additional Yahoo restrictions which you will need to investigate (http://finance.yahoo.com/badges/tos). From past experience I know you cannot redistribute Yahoo Finance data, or use it for commercial purposes.


## Installation

Add this line to your application's Gemfile:

    gem 'yahoo_finance_lib'

And then execute:

    $ bundle update

Or install it yourself as:

    $ gem install yahoo_finance_lib

## Test Before You Use
Web pages get occasionally updated -- updates could break any or all of the classes in the gem. Do not use any classes that don't pass the RSpec tests. To test, run the rspec tests from the root directory:
```
	rspec -c -f d
```

## Usage

 

Example:

```ruby
	irb
	require 'yahoo_finance'
	
	stock = YahooFinance::Stock.new(['AAPL', 'YHOO'], [:market_cap, :bid, :brokers_count, :upgrades_downgrades_history])
	# look at available fields you could fetch with this library
	stock.available_fields
	
	stock.add_field(:last_trade_price_only)

	results = stock.fetch
	aapl_bid = results["AAPL"][:bid]
	yhoo_last = results["YHOO"][:last_trade_price_only]
```

A simple interface using yahoo_stock to fetch history. It returns history as an array of hashes, e.g.

```ruby
	irb
	require 'yahoo_finance'
	require 'date'
	
	start_date = Date.today - 30
	history = YahooFinance::StockHistory.new('AAPL', start_date) # when you don't specify end date, end date = today - 1
	history.fetch
```

A simple interface to scrape financial statements - Income Statement, Balance Sheet, and Cash Flow. It can fetch either quarterly or annual data, and it returns the value in a hash. e.g.

```ruby
	irb
	require 'yahoo_finance'
	
	income_stmt = YahooFinance::FinancialStatement::QuarterlyIncomeStatementPage.new 'YHOO'
	result = income_stmt.fetch
	most_recent_qtr = income_stmt.statement_periods[0]
	available_fields = income_stmt.available_fields
	
	puts "Net income for the most recent quarter ending on #{most_recent_qtr.to_s} is #{result[:net_income][0]}"
```

The classes for the  financial statement are: QuarterlyIncomeStatementPage, AnnualIncomeStatementPage, AnnualBalanceSheetPage, QuarterlyBalanceSheetPage, QuarterlyCashFlowStatementPage, AnnualCashFlowStatementPage
	
!-- ## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request -->
