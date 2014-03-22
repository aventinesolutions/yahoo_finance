require "yahoo_finance/version"
require 'nokogiri'
require 'open-uri'

module YahooFinance
  class Page
    @symbols = []
    @available_fields = {
      :PE_trailing => "Trailing P/E (ttm, intraday):"
    }
    @fields = []
    
    def initialize(symbols)
      @symbols = symbols
    end
    
    def symbols
      return @symbols
    end
    
    def fields
      return @fields
    end
    
    def add_symbol(aSymbol)
      aSymbol = aSymbol.strip || ""
      @symbols << aSymbol if (aSymbol != "" && (@symbols.include?(aSymbol) == false))
    end
    
  end
end
