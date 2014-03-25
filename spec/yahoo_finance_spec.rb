require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

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
end
