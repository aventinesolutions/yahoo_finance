require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe YahooFinance::CompanyEvents do
  # before(:each) do
  #   @tsymbols = ['AAPL', 'DDD']
  #   @page = YahooFinance::Page.new(@tsymbols)
  # end
  
  describe "Company Events" do
    it "available stats should include things like :next_earnings_announcement_date" do
      YahooFinance::CompanyEvents.key_events_available.include?(:next_earnings_announcement_date).should == true
    end
    it "should fetch a  stat like :next_earnings_announcement_date for AAPL and should be either Date, and Array of two dates, or String" do
      pg = YahooFinance::CompanyEvents::CompanyEventsPage.new('AAPL')
      pg.fetch
      aapl_next_earnings_date = pg.value_for :next_earnings_announcement_date
      case aapl_next_earnings_date.class.name
        when "Date" then aapl_next_earnings_date.class.name.should == "Date"
        when "Array" then aapl_next_earnings_date.size.should == 2 && aapl_next_earnings_date[0].class.name.should == "Date" && aapl_next_earnings_date[1].class.name.should == "Date"
        when "String" then aapl_next_earnings_date.class.name.should == "String"
      else
        aapl_next_earnings_date.class.name.should == "Date" #force a failure
      end
      
    end
  end
end
