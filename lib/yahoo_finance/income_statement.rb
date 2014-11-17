require 'open-uri'
require 'nokogiri'
require 'date'

module YahooFinance
  module IncomeStatement
    AVL_KEY_STATS = {
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
    def IncomeStatement.key_events_available 
      return AVL_KEY_STATS.keys;
    end

    # Quarterly Data
    class IncomeStatementPage
      attr_accessor :symbol
    
      def initialize symbol=nil
        @symbol = symbol
        @term = :quarterly
        @periods = []
        @number_multiplier = 1000     # all numbers in the statements are in thousands... I need to verify whether I need to parse that
        @income_statement = {}
      end
      
      def term= aValue
        if term == :quarterly || term == :annual
          @term = term
        end
      end
      
      def doc
        @doc
      end
      
      def fetch
        url = "http://finance.yahoo.com/q/is?s=#{@symbol}&#{@term.to_s}"
        open(url) do |stream|
          @doc = Nokogiri::HTML(stream)
        end
        # let's initialize periods: by finding 'Period Endinng
        row = @doc.xpath("//span[text() = 'Period Ending']")[0].parent.parent.parent
        period1 = Date.parse(row.children[1].text)
        period2 = Date.parse(row.children[2].text)
        period3 = Date.parse(row.children[3].text)
        period4 = Date.parse(row.children[4].text)
        @periods = [period1, period2, period3, period4]
        @income_statement[:statement_periods] = @periods
        
        # YahooFinance.parse_financial_statement_field field, multiplier
        # let's fetch everything here & store in the income statement
        YahooFinance::IncomeStatement::AVL_KEY_STATS.keys.each do |incst_key|
          next if incst_key == :statement_periods
          path_expr = "//td[text()[contains(., '" + YahooFinance::IncomeStatement::AVL_KEY_STATS[incst_key][0]  +"')]]"
          row = nil
          elem = @doc.xpath(path_expr)
          index = 1
          if elem && elem.size == 0
            # this is because we have a strong type; let's try again
            path_expr = "//td/strong[text()[contains(., '" + YahooFinance::IncomeStatement::AVL_KEY_STATS[incst_key][0]  +"')]]"
            elem = @doc.xpath(path_expr)
            if elem.size > 0
              row = elem[0].parent.parent
              index = row.children.index(elem[0].parent)
            end
          else
            row = elem[0].parent
            index = row.children.index(elem[0])
          end
          if elem && elem.size > 0
            # puts "\tFOUND!!!! PATH EXPRESSION IS #{path_expr} "
            # puts "\t\tROW: #{row}"
            field1 = row.children[index+1].text.tr('^[0-9\,\.\-\(\)]', '')
            field2 = row.children[index+2].text.tr('^[0-9\,\.\-\(\)]', '')
            field3 = row.children[index+3].text.tr('^[0-9\,\.\-\(\)]', '')
            puts "Parsing: #{incst_key}:1    <<<#{field1}>>>"
            puts "Parsing: #{incst_key}:2    <<<#{field2}>>>"
            puts "Parsing: #{incst_key}:3    <<<#{field3}>>>"
            rs1 = YahooFinance.parse_financial_statement_field(field1, @multiplier)
            puts "RESULTED PARSING FOR #{rs1}"
            rs2 = YahooFinance.parse_financial_statement_field(field2, @multiplier)
            puts "RESULTED PARSING FOR #{rs2}"
            rs3 = YahooFinance.parse_financial_statement_field(field3, @multiplier)
            puts "RESULTED PARSING FOR #{rs3}"
            @income_statement[incst_key] = [ rs1, rs2, rs3 ]
            puts "\tPARSED #{incst_key}"
          else
            puts "\tNOT FOUND!!!! #{incst_key}"
          end
        end
        @income_statement
      end
      
      def statement_periods
        @periods
      end
       
      def value_for key_stat
        begin
        end
        return nil
      end  
    end

    class AnnualIncomeStatementPage < IncomeStatementPage
      def initialize symbol = nil
        super initialize symbol
        term = :annual
      end
    end

  end
end
