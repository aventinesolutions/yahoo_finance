require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe YahooFinance::KeyStatistics do
  # before(:each) do
  #   @tsymbols = ['AAPL', 'DDD']
  #   @page = YahooFinance::Page.new(@tsymbols)
  # end
  
  describe "key statistics" do
    it "available stats should include things like Price_to_Sales" do
      YahooFinance::KeyStatistics::key_stats_available.include?(:price_to_sales).should == true
    end
    it "should fetch a key stat like :total_debt_to_equity for AAPL" do
      pg = YahooFinance::KeyStatistics::StatsPage.new('AAPL')
      pg.fetch
      aapl_total_debt_to_equity = pg.value_for :total_debt_to_equity
      aapl_total_debt_to_equity.class.name.should == "Float"
      aapl_total_debt_to_equity.should >= 0.0
    end
  end
end
