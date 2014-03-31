require 'open-uri'
require 'nokogiri'

module YahooFinance
  module KeyStatistics
    AVL_KEY_STATS = {
      :market_cap => ['Market Cap ', "Market Cap, intraday"],
      :enterprise_value => ['Enterprise Value ', "Enterprise Value"],
      :trailing_pe => ['Trailing P\/E \(ttm\, intraday\)\:', "Trailing PE, trailing twelve months, intraday (based on price)"],
      :forward_pe => ['Forward P\/E ', "Forward P/E"],
      :peg_ratio => ['PEG Ratio ', "PEG Ratio (5 year expected (forward looking))"],
      :price_to_sales_ttm => ['Price\/Sales  \(ttm\)\:', "Price/Sales, trailing 12 months"],
      :price_to_book_mrq => ['Price\/Book \(mrq\):', "Price/Book, most recent quarter"],
      :roa_ttm => ['Return on Assets \(ttm\)\:', "Return on Assets, trailing twelve months"],
      :roe_ttm => ['Return on Equity \(ttm\)\:', "Return on Equity, trailing twelve months"],
      :total_debt_to_equity_mrq => ['Total Debt\/Equity \(mrq\):', "Total Debt/Equity, most recent quarter"],
      :book_value_per_share_mrq => ['Book Value Per Share \(mrq\):', "Book Value per share, most recent quarter"],
      # Income Statement
      :revenue_ttm => ['Revenue \(ttm\)\:', "Revenue, trailing twelve months"],
      :revenue_per_share_ttm => ['Revenue Per Share \(ttm\)\:', "Revenue per share, trailing twelve months"],
      :qtrly_revenue_growth_yoy => ['Qtrly Revenue Growth \(yoy\)\:', "Quarterly Revenue Growth, year on year"],
      :diluted_eps_ttm => ['Diluted EPS \(ttm\)\:', "Diluted Earnings per share, trailing twelve months"],
      :qtrly_earnings_growth_yoy => ['Qtrly Earnings Growth \(yoy\)\:', "Quarterly Earnings Growth, year on year"],
      # Balance Sheet
      :total_cash_mrq => ['Total Cash \(mrq\)\:', "Total Cash, most recent quarter"],
      :total_cash_per_share_mrq => ['Total Cash Per Share \(mrq\)\:', "Total Cash per Share, most recent quarter"],
      :total_debt_mrq => ['Total Debt (mrq):', "Total Debt, most recent quarter"],
      :total_debt_to_equity_mrq => ['Total Debt/Equity \(mrq\)\:', "Total Debt/Equity (expressed as a percentage), most recent quarter"],
      :current_ratio_mrq => ['Current Ratio \(mrq\)\:', "Total Current Assets / Total Current Liabilities, most recent quarter"],
      :book_value_per_share_mrq => ['Book Value Per Share \(mrq\)\:', "Total Common Equity / Total Common Shares Outstanding, most recent quarter"],
      # Trading additional info:
      :beta => ['Beta\:', "Equity monthly beta relative to S&P500. Uses 36 months when available."],
      # Share Statistics
      :pcnt_held_by_insiders => ['\% Held by Insiders', "Percent of shares held by insiders (returned as a fraction of 1)"],
      :pcnt_held_by_institutions => ['\% Held by Institutions', "Percent of shares held by institutions (returned as a fraction of 1)"],
      :pcnt_short_of_float => ['Short % of Float \(', "Percent of shares shorted relative to total (returned as a fraction of 1)"]
      # ,
      # # Profitability
      # :Profit_Margin,
      # :Operating_Margin,
      # # Mgt Effectiveness
      # :Return_on_Assets,
      # :Return_on_Equity,
      # # Income Stmt
      # :Qtrly_Revenue_Growth_yoy,
      # :EBITDA,
      # :Qtrly_Earnings_Growth_yoy,
      # # Balance Sheet
      # :Total_Cash_mrq,
      # :Total_Debt_mrq,
      # :Total_Debt_to_Equity_mrq,
      # :Book_Value_per_share_mrq,
      # :Total_Assets_to_Total_Liabilities,
      # # Shares
      # :Shares_Outstanding,
      # :Pcnt_Shares_Held_by_Insiders,
      # :Pcnt_Shares_Held_by_Institutions,
      # :Shares_Short,
      # :Shares_Short_Date,
      # :Short_Ratio,
      # :Shares_Short_prior_month,
      # # Dividends
      # :Fwd_Annual_Dividend_Yield,
      # :Trailing_Annual_Dividend_Yield,
      # :Five_Year_Average_Dividend_Yield,
      # :Next_Ex_Dividend_Date,
      # :Next_Dividend_Date
    }
    def KeyStatistics.key_stats_available
      return AVL_KEY_STATS.keys;
    end

    class StatsPage
      @page_keys = []
      @page_values = []
      @symbol
    
      def initialize symbol
        @symbol = symbol
      end
      
      def fetch
        url = "http://finance.yahoo.com/q/ks?s=#{@symbol}"
        doc = Nokogiri::HTML(open(url))
        # puts "DATA IS: #{data}"
        @page_keys = doc.xpath('//td[@class="yfnc_tablehead1"]')
        @page_values = doc.xpath('//td[@class="yfnc_tabledata1"]')
      end
    
      def all_stats
        ret = {}
        mcap = value_for :Market_Cap
        ret[:Market_Cap] = mcap
        ret
      end
    
      def value_for key_stat
        return nil if !@page_keys
      
        matchstr = "#{AVL_KEY_STATS[key_stat][0]}"
        @page_keys.each_with_index do |key, i|
          if key.text.match(/^#{AVL_KEY_STATS[key_stat][0]}/)
            return YahooFinance.parse_yahoo_field @page_values[i].text.to_s
          end
        end
        return nil
      end
  
    end
  end
end