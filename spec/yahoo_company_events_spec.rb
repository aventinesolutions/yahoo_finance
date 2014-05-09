require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe YahooFinance::CompanyEvents do
  # before(:each) do
  #   @tsymbols = ['AAPL', 'DDD']
  #   @page = YahooFinance::Page.new(@tsymbols)
  # end
  
  describe "Company Events" do
    it "available stats should include things like :next_earnings_announcement_date" do
      YahooFinance::CompanyEvents::key_events_available.include?(:next_earnings_announcement_date).should == true
    end
    it "should fetch a  stat like :next_earnings_announcement_date for AAPL and should be either Date or String" do
      pg = YahooFinance::CompanyEvents::CompanyEventsPage.new('AAPL')
      pg.fetch
      aapl_next_earnings_date = pg.value_for :next_earnings_announcement_date
      aapl_next_earnings_date.class.name.should == "Date"
      case aapl_next_earnings_date.class.name
      when "Date" then aapl_next_earnings_date.class.name.should == "Date"
      when "String" then aapl_next_earnings_date.class.name.should == "String"
      else
        aapl_next_earnings_date.class.name.should == "Date" #force a failure
      end
      
    end
  end
end
