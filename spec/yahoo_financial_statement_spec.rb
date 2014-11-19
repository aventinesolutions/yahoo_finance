require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

# really more like a quick sample, more concerned about connectivity -- a better test needs to be developed to exhaustively
# test all fields to make sure Yahoo hasn't changed the format...
# %%%%%%
describe YahooFinance::FinancialStatement do
  # before(:each) do
  #   @tsymbols = ['AAPL', 'DDD']
  #   @page = YahooFinance::Page.new(@tsymbols)
  # end
  
  describe "Financial Statement" do
    it "Income Statement should include things like :next_earnings_announcement_date" do
      YahooFinance::FinancialStatement::INCOME_STMT_FIELDS.include?(:operating_income_or_loss).should == true
    end
    it "Balance Sheet should include things like :intagible_assets" do
      YahooFinance::FinancialStatement::BALANCE_SHEET_FIELDS.include?(:intagible_assets).should == true
    end
    it "Cash Flow Statement should include things like :total_cash_flow_from_operating_activities" do
      YahooFinance::FinancialStatement::CASH_FLOW_STMT_FIELDS.include?(:total_cash_flow_from_operating_activities).should == true
    end
    it "should fetch all fields for e.g. AAPL quarterly Income statement and all values should be float (except for :statement_periods)-- valid values" do
      is = YahooFinance::FinancialStatement::QuarterlyIncomeStatementPage.new 'AAPL'
      rs = is.fetch
      YahooFinance::FinancialStatement::INCOME_STMT_FIELDS.keys.each do |attr|
        fields = rs[attr]
        fields.class.name.should == "Array"
        fields.size.should == 4
        fields.each do |field|
          attr == :statement_periods ? field.class.name.should == "Date" : field.class.name.should == "Float"
        end
      end
    end
    it "should fetch all fields for e.g. AAPL annual Income statement and all values should be float (except for :statement_periods)-- valid values" do
      is = YahooFinance::FinancialStatement::AnnualIncomeStatementPage.new 'AAPL'
      rs = is.fetch
      YahooFinance::FinancialStatement::INCOME_STMT_FIELDS.keys.each do |attr|
        fields = rs[attr]
        fields.class.name.should == "Array"
        fields.size.should == 3
        fields.each do |field|
          attr == :statement_periods ? field.class.name.should == "Date" : field.class.name.should == "Float"
        end
      end
    end
    it "should fetch all fields for e.g. AAPL quarterly Balance Sheet statement and all values should be float (except for :statement_periods)-- valid values" do
      is = YahooFinance::FinancialStatement::QuarterlyBalanceSheetPage.new 'AAPL'
      rs = is.fetch
      YahooFinance::FinancialStatement::BALANCE_SHEET_FIELDS.keys.each do |attr|
        fields = rs[attr]
        fields.class.name.should == "Array"
        fields.size.should == 4
        fields.each do |field|
          attr == :statement_periods ? field.class.name.should == "Date" : field.class.name.should == "Float"
        end
      end
    end
    it "should fetch all fields for e.g. AAPL annual Balance Sheet statement and all values should be float (except for :statement_periods)-- valid values" do
      is = YahooFinance::FinancialStatement::AnnualBalanceSheetPage.new 'AAPL'
      rs = is.fetch
      YahooFinance::FinancialStatement::BALANCE_SHEET_FIELDS.keys.each do |attr|
        fields = rs[attr]
        fields.class.name.should == "Array"
        fields.size.should == 3
        fields.each do |field|
          attr == :statement_periods ? field.class.name.should == "Date" : field.class.name.should == "Float"
        end
      end
    end
    it "should fetch all fields for e.g. AAPL quarterly Cash Flow statement and all values should be float (except for :statement_periods)-- valid values" do
      is = YahooFinance::FinancialStatement::QuarterlyCashFlowStatementPage.new 'AAPL'
      rs = is.fetch
      YahooFinance::FinancialStatement::CASH_FLOW_STMT_FIELDS.keys.each do |attr|
        fields = rs[attr]
        fields.class.name.should == "Array"
        fields.size.should == 4
        fields.each do |field|
          attr == :statement_periods ? field.class.name.should == "Date" : field.class.name.should == "Float"
        end
      end
    end
    it "should fetch all fields for e.g. AAPL annual Cash Flow statement and all values should be float (except for :statement_periods)-- valid values" do
      is = YahooFinance::FinancialStatement::AnnualCashFlowStatementPage.new 'AAPL'
      rs = is.fetch
      YahooFinance::FinancialStatement::CASH_FLOW_STMT_FIELDS.keys.each do |attr|
        fields = rs[attr]
        fields.class.name.should == "Array"
        fields.size.should == 3
        fields.each do |field|
          attr == :statement_periods ? field.class.name.should == "Date" : field.class.name.should == "Float"
        end
      end
    end
    #   pg = YahooFinance::CompanyEvents::CompanyEventsPage.new('AAPL')
    #   pg.fetch
    #   aapl_next_earnings_date = pg.value_for :next_earnings_announcement_date
    #   case aapl_next_earnings_date.class.name
    #     when "Date" then aapl_next_earnings_date.class.name.should == "Date"
    #     when "Array" then aapl_next_earnings_date.size.should == 2 && aapl_next_earnings_date[0].class.name.should == "Date" && aapl_next_earnings_date[1].class.name.should == "Date"
    #     when "String" then aapl_next_earnings_date.class.name.should == "String"
    #   else
    #     aapl_next_earnings_date.class.name.should == "Date" #force a failure
    #   end
    #
  end
end
