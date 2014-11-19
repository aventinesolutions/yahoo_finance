require 'open-uri'
require 'nokogiri'
require 'date'

module YahooFinance
  module FinancialStatement
    INCOME_STMT_FIELDS = {
      :statement_periods => ['Period Ending', "Ending date per period"],
      :total_revenue => ['Total Revenue', "Total Revenue (per period)"],
      :cost_of_revenue => ['Cost of Revenue', 'Cost of Revenue (per period)'],
      :gross_profit => ['Gross Profit', 'Gross profit (per period)'],
      :research_development => ['Research Development', 'Research and Development (per period)'],
      :selling_general_and_administrative => ['Selling General and Administrative', 'Selling General and Administrative (per period)'],
      :non_recurring => ['Non Recurring', 'Non Recurring (per period)'],
      :other_expenses => ['Others', 'Other expenses (per period)'],
      :total_operating_expenses => ['Total Operating Expenses', 'Total Operating Expenses (per period)'],
      :operating_income_or_loss => ['Operating Income or Loss', 'Operating Income or Loss (per period)'],
      :total_other_income_expenses_net => ['Total Other Income/Expenses Net', 'Total Other Income/Expenses Net (per period)'],
      :EBIT => ['Earnings Before Interest And Taxes', '	Earnings Before Interest And Taxes (per period)'],
      :interest_expense => ['Interest Expense', 'Interest Expense (per period)'],
      :income_before_tax => ['Income Before Tax', 'Income Before Tax (per period)'],
      :income_tax_expense => ['Income Tax Expense', 'Income Tax Expense (per period)'],
      :minority_interest => ['Minority Interest', 'Minority Interest (per period)'],
      :net_income_from_continuing_operations => ['Net Income From Continuing Ops', 'Net Income From Continuing Ops (per period)'],
      :discontinued_operations => ['Discontinued Operations', 'Discontinued Operations (per period)'],
      :extraordinary_items =>['Extraordinary Items', 'Extraordinary Items (per period)'],
      :effect_of_accounting_changes => ['Effect Of Accounting Changes', 'Effect Of Accounting Changes (per period)'],
      :other_items => ['Other Items', 'Other Items (per period)'],
      :net_income => ['Net Income', 'Net Income (per period)'],
      :preferred_stock_and_other_adjustments => ['Preferred Stock And Other Adjustments', 'Preferred Stock And Other Adjustments (per period)'],
      :net_income_applicable_to_common_shares => ['Net Income Applicable To Common Shares', 'Net Income Applicable To Common Shares (per period)']
    }
    
    BALANCE_SHEET_FIELDS = {
      :statement_periods => ['Period Ending', "Ending date per period"],
      :cash_and_cash_equivalents => ['Cash And Cash Equivalents', 'Cash And Cash Equivalents'],
      :short_term_investments => ['Short Term Investments', '	Short Term Investments'],
      :net_receivables => ['Net Receivables', 'Net Receivables'],
      :inventory => ['Inventory', 'Inventory'],
      :other_current_assets => ['Other Current Assets', 'Other Current Assets'],
      :total_current_assets => ['Total Current Assets', 'Total Current Assets'],
      :long_term_investments => ['Long Term Investments', 'Long Term Investments'],
      :property_plant_and_equipment => ['Property Plant and Equipment', 'Property Plant and Equipment'],
      :goodwill => ['Goodwill', 'Goodwill'],
      :intagible_assets => ['Intangible Assets', 'Intangible Assets'],
      :accumulated_amortization => ['Accumulated Amortization', 'Accumulated Amortization'],
      :other_assets => ['Other Assets', 'Other Assets'],
      :deferred_long_term_asset_charges => ['Deferred Long Term Asset Charges', 'Deferred Long Term Asset Charges'],
      :total_assets => ['Total Assets', 'Total Assets'],
      :accounts_payable => ['Accounts Payable', 'Accounts Payable'],
      :short_current_long_term_debt => ['Short/Current Long Term Debt', 'Short/Current Long Term Debt'],
      :other_current_liabilities => ['Other Current Liabilities', 'Other Current Liabilities'],
      :total_current_liabilities => ['Total Current Liabilities', 'Total Current Liabilities'],
      :long_term_debt => ['Long Term Debt', 'Long Term Debt'],
      :other_liabilities => ['Other Liabilities', 'Other Liabilities'],
      :deferred_long_term_liability_charges => ['Deferred Long Term Liability Charges', 'Deferred Long Term Liability Charges'],
      :minority_interest => ['Minority Interest', 'Minority Interest'],
      :negative_goodwill => ['Negative Goodwill', 'Negative Goodwill'],
      :total_liabilities => ['Total Liabilities', 'Total Liabilities'],
      :misc_stocks_options_warrants => ['Misc Stocks Options Warrants', 'Misc Stocks Options Warrants'],
      :redeemable_preferred_stock => ['Redeemable Preferred Stock', 'Redeemable Preferred Stock'],
      :preferred_stock => ['Preferred Stock', 'Preferred Stock'],
      :common_stock => ['Common Stock', 'Common Stock'],
      :retained_earnings => ['Retained Earnings', 'Retained Earnings'],
      :treasury_stock => ['Treasury Stock', 'Treasury Stock'],
      :capital_surplus => ['Capital Surplus', 'Capital Surplus'],
      :other_stockholder_equity => ['Other Stockholder Equity', 'Other Stockholder Equity'],
      :total_stockholder_equity => ['Total Stockholder Equity', 'Total Stockholder Equity'],
      :net_tangible_assets => ['Net Tangible Assets', 'Net Tangible Assets']
    }
    
    CASH_FLOW_STMT_FIELDS = {
      :statement_periods => ['Period Ending', "Ending date per period"],
      :net_income => ['Net Income', 'Net Income'],
      :depreciation => ['Depreciation', 'Depreciation'],
      :adjustments_to_net_income => ['Adjustments To Net Income','Adjustments To Net Income'],
      :changes_in_accounts_receivables => ['Changes In Accounts Receivables', 'Changes In Accounts Receivables'],
      :changes_in_liabilities => ['Changes In Liabilities','Changes In Liabilities'],
      :changes_in_inventories => ['Changes In Inventories', 'Changes In Inventories'],
      :changes_in_other_operating_activities => ['Changes In Other Operating Activities', 'Changes In Other Operating Activities'],
      :total_cash_flow_from_operating_activities => ['Total Cash Flow From Operating Activities', 'Total Cash Flow From Operating Activities'],
      :capital_expenditures => ['Capital Expenditures', 'Capital Expenditures'],
      :investments => ['Investments', 'Investments'],
      :other_cash_flows_from_investing_activities => ['Other Cash flows from Investing Activities', 'Other Cash flows from Investing Activities'],
      :total_cash_flows_from_investing_activities => ['Total Cash Flows From Investing Activities', 'Total Cash Flows From Investing Activities'],
      :dividends_paid => ['Dividends Paid', 'Dividends Paid'],
      :sale_purchase_of_stock => ['Sale Purchase of Stock', 'Sale Purchase of Stock'],
      :net_borrowings => ['Net Borrowings', 'Net Borrowings'],
      :other_cash_flows_from_financing_activities => ['Other Cash Flows from Financing Activities', 'Other Cash Flows from Financing Activities'],
      :total_cash_flows_from_financing_activities => ['Total Cash Flows From Financing Activities', 'Total Cash Flows From Financing Activities'],
      :effect_of_exchange_rate_changes => ['Effect Of Exchange Rate Changes', 'Effect Of Exchange Rate Changes'],
      :change_in_cash_and_cash_equivalents => ['Change In Cash and Cash Equivalents', 'Change In Cash and Cash Equivalents']
    }
    

    # Quarterly Data
    class FinancialStatementPage
      attr_accessor :symbol
    
      def initialize symbol=nil
        @symbol = symbol
        @term = :quarterly
        @periods = []
        @number_multiplier = 1000.00     # all numbers in the statements are in thousands... I need to verify whether I need to parse that
        @financial_statement = {}
        @data_columns = 4
        @type="is"
        @field_defs = YahooFinance::FinancialStatement::INCOME_STMT_FIELDS
      end
      
      def term= aValue
        if term == :quarterly || term == :annual
          @term = term
        end
      end
      
     def available_fields 
        return @field_defs.keys;
      end
      
      def fetch
        url = "http://finance.yahoo.com/q/#{@type}?s=#{@symbol}&#{@term.to_s}"
        doc = nil
        open(url) do |stream|
          doc = Nokogiri::HTML(stream)
        end
        # let's initialize periods: by finding 'Period Endinng
        row = doc.xpath("//span[text() = 'Period Ending']")[0].parent.parent.parent
        period1 = Date.parse(row.children[1].text)
        period2 = Date.parse(row.children[2].text)
        period3 = Date.parse(row.children[3].text)
        @periods = [period1, period2, period3]
        if @data_columns == 4       # quarterly data
          period4 = Date.parse(row.children[4].text)
          @periods << period4
        end
        @financial_statement[:statement_periods] = @periods
        
        # YahooFinance.parse_financial_statement_field field, multiplier
        # let's fetch everything here & store in the income statement
        @field_defs.keys.each do |incst_key|
          next if incst_key == :statement_periods
          path_expr = "//td[text()[contains(., '" + @field_defs[incst_key][0]  + "')]]"
          row = nil
          elem = doc.xpath(path_expr)
          index = 1
          regex = "\\s\*#{@field_defs[incst_key][0]}\\s\*"
          if elem && elem.size == 0
            # this is because we have a strong type; let's try again
            path_expr = "//td/strong[text()[contains(., '" + @field_defs[incst_key][0]  +"')]]"
            elem = doc.xpath(path_expr)
            if elem.size > 0
              elem.each do |e|
                if e.text.match regex
                  # we found it
                  row = e.parent.parent
                end
              end
              if !row
                # wasn't found
                puts "#{@field_defs[incst_key][0]} was not found!"
                next
              end
              index = row.children.index(elem[0].parent)
            end
          else
            elem.each do |e|
              # puts "Checking #{e}: class #{e.text.class.name} with text <<#{e.text}>> and regex #{regex}"
              if e.text.match regex
                # we found it
                row = e.parent
                break
              end
            end
            if !row
              # wasn't found
              puts "#{@field_defs[incst_key][0]} was not found!"
              next
            end
            index = row.children.index(elem[0])
          end
          if elem && elem.size > 0
            # puts "\tFOUND!!!! PATH EXPRESSION IS #{path_expr} "
            # puts "\t\tROW: #{row}"
            rstbl = []
            field1 = row.children[index+1].text.tr('^[0-9\,\.\-\(\)]', '')
            field2 = row.children[index+2].text.tr('^[0-9\,\.\-\(\)]', '')
            field3 = row.children[index+3].text.tr('^[0-9\,\.\-\(\)]', '')
            rs1 = YahooFinance.parse_financial_statement_field(field1, @number_multiplier)
            rs2 = YahooFinance.parse_financial_statement_field(field2, @number_multiplier)
            rs3 = YahooFinance.parse_financial_statement_field(field3, @number_multiplier)
            rstbl = [ rs1, rs2, rs3]
            if @data_columns == 4   # with quarterly data
              field4 = row.children[index+4].text.tr('^[0-9\,\.\-\(\)]', '')
              rs4 = YahooFinance.parse_financial_statement_field(field4, @number_multiplier)
              rstbl << rs4
            end
            
            @financial_statement[incst_key] = rstbl
            # puts "\tPARSED #{incst_key}"
          else
            puts "\tNOT FOUND!!!! #{incst_key}"
          end
        end
        @financial_statement
      end
      
      def statement_periods
        @periods
      end
       
      def value_for key_stat
        begin
          return @financial_statement[key_stat]
        rescue
        end
        return nil
      end  
    end

    class QuarterlyIncomeStatementPage < FinancialStatementPage
      def initialize symbol = nil
        super symbol
        @term = :quarterly
        @data_columns = 4
        @type="is"
        @field_defs = YahooFinance::FinancialStatement::INCOME_STMT_FIELDS
      end
    end
    
    class AnnualIncomeStatementPage < FinancialStatementPage
      def initialize symbol = nil
        super symbol
        @term = :annual
        @data_columns = 3
        @type="is"
        @field_defs = YahooFinance::FinancialStatement::INCOME_STMT_FIELDS
      end
    end
    
    class QuarterlyBalanceSheetPage < FinancialStatementPage
      def initialize symbol = nil
        super symbol
        @term = :quarterly
        @data_columns = 4
        @type="bs"
        @field_defs = YahooFinance::FinancialStatement::BALANCE_SHEET_FIELDS
      end
    end

    class AnnualBalanceSheetPage < FinancialStatementPage
      def initialize symbol = nil
        super symbol
        @term = :annual
        @data_columns = 3
        @type="bs"
        @field_defs = YahooFinance::FinancialStatement::BALANCE_SHEET_FIELDS
      end
    end

    class QuarterlyCashFlowStatementPage < FinancialStatementPage
      def initialize symbol = nil
        super symbol
        @term = :quarterly
        @data_columns = 4
        @type="cf"
        @field_defs = YahooFinance::FinancialStatement::CASH_FLOW_STMT_FIELDS
      end
    end

    class AnnualCashFlowStatementPage < FinancialStatementPage
      def initialize symbol = nil
        super symbol
        @term = :annual
        @data_columns = 3
        @type="cf"
        @field_defs = YahooFinance::FinancialStatement::CASH_FLOW_STMT_FIELDS
      end
    end

  end
end
