require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe YahooFinance do
  describe "Parsing Yahoo Fields" do
    it "should parse an int correctly, such as \"3\"" do
      YahooFinance.parse_yahoo_field("3").should == 3
    end
    it "should parse a float correctly, such as \"3.25\"" do
      YahooFinance.parse_yahoo_field("3.25").should == 3.25
    end
    it "should parse a float with comma separated 000s correctly, such as \"3,245.25\"" do
      YahooFinance.parse_yahoo_field("3,245.25").should == 3245.25
    end
    it "should parse a negative float with comma separated 000s correctly, such as \"-3,245.25\"" do
      YahooFinance.parse_yahoo_field("-3,245.25").should == -3245.25
    end
    it "should parse a scaled float correctly, such as \"3.25K\"" do
      YahooFinance.parse_yahoo_field("3.25K").should == 3250.0
    end
    it "should parse a scaled float correctly, such as \"3.25B\"" do
      YahooFinance.parse_yahoo_field("3.25B").should == 3250000000.0
    end
    it "should parse a date, such as 'Feb 3, 2009'" do
      dt = YahooFinance.parse_yahoo_field("Feb 3, 2009")
      dt.class.name.should == "Date"
      dt.month.should == 2
      dt.day.should == 3
      dt.year.should == 2009
    end
    it "should recognize that a string like 'hello 1, 2000' is a string and neither a number or a date" do
      str = YahooFinance.parse_yahoo_field("hello 1, 2000")
      str.class.name.should == "String"
      str.should == "hello 1, 2000"
    end
  end
end

describe YahooFinance::Stock do
  before(:each) do
    @tsymbols = ['AAPL', 'DDD']
    @stock = YahooFinance::Stock.new(@tsymbols)
  end
  
  describe "initialization" do
    it "should remember the symbols it was initialized with" do
      @stock.symbols.uniq.sort.should == @tsymbols
    end
    
    it "should allow you to add a symbol" do
      @stock.add_symbol('TEST')
      @stock.symbols.size == 3
      # puts "#{@page.symbols.to_s}"
      @stock.symbols.uniq.sort.should == @tsymbols
    end
  end
  
  describe "execution - fetching yahoo_stock outputs" do
    it "should return value for a field such as :p_e_ratio, and it should be of type float" do
      @stock.add_field(:p_e_ratio)
      results = @stock.fetch
      # puts "GOT RESULTS: #{results[0][:p_e_ratio]}"
      # let's parse the output
      pe_ratio = YahooFinance.parse_yahoo_field(results[0][:p_e_ratio]) 
      pe_ratio.class.name.should == "Float"
    end
    it "should return value for a field such as :bid and it should be of type float, or should return 'N/A'" do
      @stock.add_field(:bid)
      results = @stock.fetch
      # puts "GOT RESULTS: #{results[0][:p_e_ratio]}"
      # let's parse the output
      bid = YahooFinance.parse_yahoo_field(results[0][:bid]) 
      case bid.class.name
      when "Float" then bid.class.name.should == "Float"
      when "String" then bid.should == "N/A"
      else
        bid.class.name.should == "Float" #force a failure
      end
    end
  end
end
