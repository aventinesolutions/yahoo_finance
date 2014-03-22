require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe YahooFinance::Page do
  before(:each) do
    @tsymbols = ['AAPL', 'DDD']
    @page = YahooFinance::Page.new(@tsymbols)
  end
  
  describe "key statistics" do
    it "available stats should include things like Price_to_Sales" do
      @page.key_stats_available.include?(:Price_to_Sales).should == true
    end
    
  end
end
