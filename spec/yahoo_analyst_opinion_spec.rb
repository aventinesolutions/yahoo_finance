require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe YahooFinance::AnalystOpinion do
  # before(:each) do
  #   @tsymbols = ['AAPL', 'DDD']
  #   @page = YahooFinance::Page.new(@tsymbols)
  # end
  
  describe "Analyst Opinion" do
    it "available stats should include things like :brokers_count" do
      YahooFinance::AnalystOpinion.key_events_available.include?(:brokers_count).should == true
    end
    it "should fetch a  stat like :brokers_count for AAPL and should greater than zero" do
      pg = YahooFinance::AnalystOpinion::AnalystOpinionPage.new('AAPL')
      pg.fetch
      aapl_brokers_count = pg.value_for :brokers_count
      aapl_brokers_count.should > 0
    end
  end
end
