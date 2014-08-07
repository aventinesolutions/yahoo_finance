# YahooFinanceStock

YahooFinance lib is a gem that fetches stock quotes, key statistics, company events, and analyst opinion from Yahoo (TM) API and financial HTML pages. The loading of stock quotes uses the excellent nas/yahoo_stock gem. This gem provides a 'unified' attribute based interface, and abstracts the source of the information, i.e. the user only needs to specify an attribute without the need to specify the page source of the attribute. This gem leverages to the highest extend possible the YahooStock (yahoo_stock_nas) gem for all the attributes provided by that gem, and fails over to HTML scraping when the data is unavailable there. Naturally, this has an implication on performance; YahooStock queries bundle 50 stocks in each query, whereas HTML scraping happens one page per stock at a time.

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

## Usage

Note that 

Example:
	irb
	require 'rubygems'
	require 'yahoo_finance'
	
	stock = YahooFinance::Stock.new(['AAPL', 'YHOO'], [:market_cap, :bid, :brokers_count, :upgrades_downgrades_history])
	# look at available fields you could fetch with this library
	stock.available_fields
	
	stock.add_field(:last_trade_price_only)

	results = stock.fetch
	aapl_bid = results["AAPL"][:bid]
	yhoo_last = results["YHOO"][:last_trade_price_only]
	
!-- ## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request -->
