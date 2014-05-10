# YahooFinance

YahooFinance is a gem that fetches stock quotes & key statistics from Yahoo (TM) API and financial HTML pages. This gem provides a 'unified' attribute based interface, and abstracts the source of the information, i.e. the user only needs to specify an attribute without the need to specify the page source of the attribute. This gem leverages to the highest extend possible the YahooStock (yahoo_stock_nas) gem for all the attributes provided by that gem, and fails over to HTML scraping when the data is unavailable there. Naturally, this has an implication on performance; YahooStock queries bundle 50 stocks in each query, whereas HTML scraping happens one page per stock at a time.

#####This gem is currently still in development. HTML scraping now supports many attributes from Key Statistics and also supports earnings announcements from the Company Events page -- additional pages will be added as I find time.

#####Caveat: HTML parsing is susceptible to HTML encoding of Yahoo Finance pages; when these pages change, parsing will break. Core Yahoo API attributes from YahooStock will entirely depend on YahooStock continuing to support the Yahoo APIs.

#####Use the code entirely at your own risk, and subject to copyright & trademark restrictions on Yahoo Finance(TM). I am quite sure that are additional Yahoo restrictions which you will need to investigate (http://finance.yahoo.com/badges/tos). From past experience I know you cannot redistribute Yahoo Finance data, or use it for commercial purposes.


## Installation

Add this line to your application's Gemfile:

    gem 'yahoo_finance'

And then execute:

    $ bundle update

Or install it yourself as:

    $ gem install yahoo_finance

## Usage

TODO: Write usage instructions here

<!-- ## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request -->
