
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
  
  # We are not interested parsing every type of field
  # Key Fields: number (that may include , for 000s separator, NOT SUPPORTED YET), scaled number
  #             percentage, date
  def YahooFinance.parse_yahoo_field aField
    # we really need to oarse numbers, dates, and strings %%% STUB ALERT %%%%

    aField.strip!
    
    if aField.match /^([\-]{,1})([\d\,])*(\.[\d]+)*$/
      # it's a number as far as we care; let's strip the commas....
      aField.gsub! /\,/, ''
    end

    m=aField.match  /^([\-]{0,1})([\d]*)(\.[\d]{1,})([KB\%]{0,1})$/
    if m # && (m.size == 3)
      num = ((m[1] || "")+(m[2] || "")+(m[3] || "")).to_f

      case m[4]
      when "K" then
        num *= 1000
        # puts "NUM got K = #{num.to_s}"
      when "B" then
        num *= 1000000
        # puts "NUM got B = #{num.to_s}"
      when '%' then
        num /= 100
        # puts "NUM got % = #{num.to_s}"
      end
      return num
    end

    if aField.match /^([\-]*[0-9]*)(\.[0-9]*)*$/
      # simple number
      return aField.to_f
    end
    
    
    m=aField.match /^(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[\s]+([\d]{1,2})\,[\s]*([\d]{4})$/
    if m
      # got a date
      dt = nil
      begin
        dt = Date.strptime aField, '%b %d, %Y'
      rescue
      end
      return dt if dt
    end
    
    aField
  end
  
  class Stock
    @@available_fields = [] | AVL_FIELDS[:YAHOO_STOCK_FIELDS]
    @symbols = []
    @fields = []
    @fields_hash = {}
    @results_hash = {}
    
    def initialize(symbols, fields = nil)
      @symbols = symbols
      @fields = []
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
    
    def fetch
      allocate_fields_to_connections
      if @fields_hash[:YAHOO_STOCK_FIELDS].size > 0
        # puts "SYMBOLS ARE: #{@symbols.to_s} AND PARAMETERS: #{@fields_hash[:YAHOO_STOCK_FIELDS].to_s}"
        qt = YahooStock::Quote.new(:stock_symbols => @symbols)
        qt.add_parameters(:symbol)
        @fields_hash[:YAHOO_STOCK_FIELDS].each do |aField|
          qt.add_parameters(aField)
        end
        yshs = qt.results(:to_hash).output
        # here we need to add StockQuote outputs to @results_hash
      end
      # if @fields_hash[:KEY_STATISTICS].size > 0
      # end
      yshs
    end
    
    def allocate_fields_to_connections
      @fields_hash = {}
      @fields_hash[:YAHOO_STOCK_FIELDS] = []
      @fields_hash[:KEY_STATISTICS] = []
      @fields.each do |aField|
        if AVL_FIELDS[:YAHOO_STOCK_FIELDS].include? aField
          @fields_hash[:YAHOO_STOCK_FIELDS] << aField
        elsif AVL_FIELDS[:KEY_STATISTICS].include? aField
          @fields_hash[:KEY_STATISTICS] << aField
        end
      end
    end
  end
end
