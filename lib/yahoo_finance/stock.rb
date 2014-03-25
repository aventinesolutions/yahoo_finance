
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
  class Stock
    @@available_fields = [] | AVL_FIELDS[:YAHOO_STOCK_FIELDS]
    @symbols = []
    @fields = []
    
    def initialize(symbols, fields = nil)
      @symbols = symbols
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
    
    def add_field(aField)
      if @@available_fields.include? aField
        @fields << aField
      end
    end
    
    
  end
end
