require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe YahooFinance::CompanyProfile do
  
  describe "Company Profile" do
    it "available stats should include things like :sector" do
      YahooFinance::CompanyProfile.key_events_available.include?(:sector).should == true
    end
    it "should fetch a  stat like :brokers_count for AAPL and should greater than zero" do
      pg = YahooFinance::CompanyProfile::CompanyProfilePage.new('AAPL')
      pg.fetch
      aapl_sector = pg.value_for :sector
      aapl_sector.should_not be_nil
    end
  end
end