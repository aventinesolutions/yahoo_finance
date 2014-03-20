require "yahoo_finance/version"
require 'nokogiri'
require 'open-uri'

module YahooFinance
  class Page
    @symbols = []
    @key_stats_fields = {
      :PE_trailing => "Trailing P/E (ttm, intraday):"
    }
    
    def initialize(symbols)
      @symbols = symbols
    end
    
    def symbols
      return @symbols
    end
    
    def add_symbol(aSymbol)
      aSymbol = aSymbol.strip || ""
      @symbols << aSymbol if (aSymbol != "" && (@symbols.include?(aSymbol) == false))
    end
    
    def key_statistics for_symbol
      url = "http://finance.yahoo.com/q/ks?s=#{for_symbol}"
      data = Nokogiri::HTML(open(url))
      
      # we got data, now we are scraping
      
    end

    def key_statistics
      return nil if @symbols.size == 0
      
    end
  end
end
