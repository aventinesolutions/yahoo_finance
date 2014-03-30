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
      :revenue_ttm => ['Revenue \(ttm\)\:', "Revenue, trailing twelve months"],
      :roa_ttm => ['Return on Assets \(ttm\)\:', "Return on Assets, trailing twelve months"],
      :roe_ttm => ['Return on Equity \(ttm\)\:', "Return on Equity, trailing twelve months"],
      :total_debt_to_equity_mrq => ['Total Debt\/Equity \(mrq\):', "Total Debt/Equity, most recent quarter"],
      :book_value_per_share_mrq => ['Book Value Per Share \(mrq\):', "Book Value per share, most recent quarter"]
      # ,
      # :Price_to_Book,
      # :Enterprise_Value_to_Revenue,
      # :Enterprise_Value_to_EBITDA,
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