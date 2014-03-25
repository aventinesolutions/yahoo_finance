
require 'yahoo_stock'

#YahooStock::Quote.new(:stock_symbols => ['AAPL']).valid_parameters,
# {
# #   :PE_trailing => "Trailing P/E (ttm, intraday):"
# }

module YahooFinance
  AVL_FIELDS = {
    :YAHOO_STOCK_FIELDS => YahooStock::Quote.new(:stock_symbols => ['AAPL']).valid_parameters,
    :KEY_STATISTICS => []
  }
  class Page
    @@available_fields = [] | AVL_FIELDS[:YAHOO_STOCK_FIELDS]
    @symbols = []
    @fields = []
    
    def initialize(symbols)
      @symbols = symbols
      if !@@available_fields then
        @@available_fields = [] | AVL_FIELDS[:YAHOO_STOCK_FIELDS]
      end
    end
    
    def symbols
      return @symbols
    end
    
    def fields
      return @fields
    end
    
    def available_fields
      @@available_fields
    end  
    
    def add_symbol(aSymbol)
      aSymbol = aSymbol.strip || ""
      @symbols << aSymbol if (aSymbol != "" && (@symbols.include?(aSymbol) == false))
    end
  end
end
