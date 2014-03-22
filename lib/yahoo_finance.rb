require "yahoo_finance/version"
require 'nokogiri'
require 'open-uri'
require 'yahoo_finance/key_statistics'

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
    

    include KeyStatistics
    def key_stats
      return nil if @symbols.size == 0
      results = []
      @symbols.each do |symbol|
        results.push(KeyStatistics::fetch(symbol))
      end
      results
    end
    
    def key_stats_available
      return KeyStatistics::key_stats_available;
    end

  end
end
