require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe YahooFinance::Page do
  before(:each) do
    @tsymbols = ['AAPL', 'DDD']
    @page = YahooFinance::Page.new(@tsymbols)
  end
  
  describe "initialization" do
    it "should remember the symbols it was initialized with" do
      @page.symbols.uniq.sort.should == @tsymbols
    end
    
    it "should allow you to add a symbol" do
      @page.add_symbol('TEST')
      @page.symbols.size == 3
      # puts "#{@page.symbols.to_s}"
      @page.symbols.uniq.sort.should == @tsymbols
    end
  end
end
