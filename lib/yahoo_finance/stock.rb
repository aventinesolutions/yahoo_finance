
require 'yahoo_stock'
require 'yahoo_finance/key_statistics'
require 'yahoo_finance/company_events'
require 'yahoo_finance/analyst_opinion'


module YahooFinance
  AVL_FIELDS = {
    :YAHOO_STOCK_FIELDS => YahooStock::Quote.new(:stock_symbols => ['AAPL']).valid_parameters,
    :KEY_STATISTICS => YahooFinance::KeyStatistics.key_stats_available,
    :COMPANY_EVENTS => YahooFinance::CompanyEvents.key_events_available,
    :ANALYST_OPINION => YahooFinance::AnalystOpinion.key_events_available
  }
  DRIVERS = {
    :KEY_STATISTICS => YahooFinance::KeyStatistics::StatsPage,
    :COMPANY_EVENTS => YahooFinance::CompanyEvents::CompanyEventsPage,
    :ANALYST_OPINION => YahooFinance::AnalystOpinion::AnalystOpinionPage
  }
  
  # We are not interested parsing every type of field
  # Key Fields: number (that may include , for 000s separator, NOT SUPPORTED YET), scaled number
  #             percentage, date
  def YahooFinance.parse_yahoo_field aField
    # we really need to oarse numbers, dates, and strings %%% STUB ALERT %%%%

    aField.strip!
    
    if aField.match /^([\-\+]{,1})([\d\,])*(\.[\d]+)*$/
      # it's a number as far as we care; let's strip the commas....
      aField.gsub! /\,/, ''
    end

    m=aField.match  /^([\-\+]{0,1})([\d]*)(\.[\d]{1,})([KMB\%]{0,1})$/
    if m # && (m.size == 3)
      num = ((m[1] || "")+(m[2] || "")+(m[3] || "")).to_f

      case m[4]
      when "K" then
        num *= 1000
        # puts "NUM got K = #{num.to_s}"
      when "M" then
        num *= 1000000
        # puts "NUM got B = #{num.to_s}"
      when "B" then
        num *= 1000000000
        # puts "NUM got B = #{num.to_s}"
      when '%' then
        num /= 100
        # puts "NUM got % = #{num.to_s}"
      end
      return num
    end

    if aField.match /^([\-\+]*[0-9]*)(\.[0-9]*)*$/
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
    
    #else make an attempt to parse as date
    dt = nil
    begin
      dt = Date.parse(aField)
    rescue
    end
    return dt if dt
    
    aField
  end
  
  class Stock
    @@available_fields = (AVL_FIELDS[:YAHOO_STOCK_FIELDS] + AVL_FIELDS[:KEY_STATISTICS] + AVL_FIELDS[:COMPANY_EVENTS] + AVL_FIELDS[:ANALYST_OPINION])
    @@insert_variable_delays = true
    @@insert_variable_delay = 4
    @@retry_times = 3
    @@retry_variable_delay = 30
    @symbols = []
    @fields = []
    @fields_hash = {}
    @results_hash = {}
    
    def self.insert_variable_delays
      @@insert_variable_delays
    end
    
    def self.insert_variable_delays= trueFalse
      @@insert_variable_delays = trueFalse
    end
    
    def self.insert_variable_delay
      @@insert_variable_delay
    end
    
    def self.insert_variable_delay= aDelay
      @@insert_variable_delay = aDelay
    end
    
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
    
    # NOTE -- UPDATE THIS WHEN YOU ADD A NEW PAGE %%
    def available_fields_and_descriptions
      ysh = {}; YahooFinance::AVL_FIELDS[:YAHOO_STOCK_FIELDS].each { |field| ysh[field] = "" }
      ysh.merge(YahooFinance::KeyStatistics::AVL_KEY_STATS).merge(YahooFinance::CompanyEvents::AVL_KEY_STATS)
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
      # initialize symbol rows
      @results_hash = {}
      @symbols.each do |aSymbol|
        @results_hash[aSymbol.upcase] = {}    # we do this to avoid problems with symbols misstyped with mixed upper/lower case
      end
      
      # First we fetch symbols under YAHOO_STOCK_FIELDS
      if @fields_hash[:YAHOO_STOCK_FIELDS].size > 0
        # puts "SYMBOLS ARE: #{@symbols.to_s} AND PARAMETERS: #{@fields_hash[:YAHOO_STOCK_FIELDS].to_s}"

        # Yahoo Stock API has some limits, therefore, we need to chunk the symbols
        @symbols.each_slice(50).to_a.each do |symbol_slice|

          qt = YahooStock::Quote.new(:stock_symbols => symbol_slice)
          qt.add_parameters(:symbol)
          @fields_hash[:YAHOO_STOCK_FIELDS].each do |aField|
            qt.add_parameters(aField)
          end
        
          yshs = qt.results(:to_hash).output
          @fields_hash[:YAHOO_STOCK_FIELDS].each do |aField|
            yshs.each do |aSymbolRow|
              symbol = aSymbolRow[:symbol]
              value = aSymbolRow[aField]
              begin
                @results_hash[symbol][aField] = YahooFinance.parse_yahoo_field(value)
              rescue Exception => e
                puts "Failed in symbol #{symbol.to_s} field #{aField.to_s} value #{(value || "NULL").to_s}"
                puts "RESULT ROW: #{aSymbolRow.to_s}"
              end
            end
          end
          sleep(Random.new(Random.new_seed).rand*@@insert_variable_delay)  if @@insert_variable_delays
        end
      end
      # Then we fetch fields from KEY STATISTICS
      DRIVERS.keys.each do |driver|
        # puts "CHECKING #{driver.to_s}"
        if @fields_hash[driver].size > 0
          # puts "FETCHING FIELDS FOR #{driver.to_s}"
          @symbols.each do |aSymbol|
            tries = 0
            begin
              stp = DRIVERS[driver].new(aSymbol)
              stp.fetch
              @fields_hash[driver].each do |aField|
                value = stp.value_for(aField) # this already parses the numbers
                @results_hash[aSymbol][aField] = value
              end
              sleep(Random.new(Random.new_seed).rand*@@insert_variable_delay)  if @@insert_variable_delays
            rescue
              tries += 1
              sleep(@@retry_variable_delay)
              retry if tries <= @@retry_times
            end
          end
        end
      end
      @results_hash
    end
        
    def allocate_fields_to_connections
      @fields_hash = {}
      AVL_FIELDS.keys.each do |driver|
        @fields_hash[driver] = []
      end
      
      @fields.each do |aField|
        if AVL_FIELDS[:YAHOO_STOCK_FIELDS].include? aField
          @fields_hash[:YAHOO_STOCK_FIELDS] << aField
        else
          DRIVERS.keys.each do |driver|
            # puts "CHECKING DRIVER: #{driver} for field #{aField}"
            if AVL_FIELDS[driver].include? aField
              @fields_hash[driver] << aField
            end
          end
        end
      end
      #
      # @fields_hash[:YAHOO_STOCK_FIELDS] = []
      # @fields_hash[:KEY_STATISTICS] = []
      # @fields_hash[:COMPANY_EVENTS] = []
      # @fields_hash[:ANALYST_OPINION] = []
      # @fields.each do |aField|
      #   if AVL_FIELDS[:YAHOO_STOCK_FIELDS].include? aField
      #     @fields_hash[:YAHOO_STOCK_FIELDS] << aField
      #   elsif AVL_FIELDS[:KEY_STATISTICS].include? aField
      #     @fields_hash[:KEY_STATISTICS] << aField
      #   elsif AVL_FIELDS[:COMPANY_EVENTS].include? aField
      #     @fields_hash[:COMPANY_EVENTS] << aField
      #   elsif AVL_FIELDS[:ANALYST_OPINION].include? aField
      #     @fields_hash[:ANALYST_OPINION] << aField
      #   end
      # end
    end
  end
end
