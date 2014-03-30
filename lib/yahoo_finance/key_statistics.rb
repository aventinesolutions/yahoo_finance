require 'open-uri'
require 'nokogiri'

module YahooFinance
  module KeyStatistics
    AVL_KEY_STATS = {
      :market_cap => ['Market Cap ', :float],
      :enterprise_value => ['Enterprise Value ', :float],
      :trailing_pe => ['Trailing P\/E ', :float],
      :forward_pe => ['Forward P\/E ', :float],
      :peg_ratio => ['PEG Ratio ', :float],
      :price_to_sales => ['Price\/Sales ', :float],
      :revenue_ttm => ['Revenue \(ttm\)\:', :float],
      :roa => ['Return on Assets', :float],
      :roe => ['Return on Equity', :float],
      :total_debt_to_equity => ['Total Debt\/Equity', :float],
      :book_value_per_share => ['Book Value Per Share', :float]
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