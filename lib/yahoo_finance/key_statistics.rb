require 'open-uri'
require 'nokogiri'

module KeyStatistics
  class StatsPage
    AVL_KEY_STATS = {
      :Market_Cap => ['Market Cap ', :float],
      :Enterprise_Value => ['Enterprise Value \(', :float],
      :Trailing_PE => ['Trailing P\/E \(ttm, intraday\)', :float],
      :Forward_PE => ['Forward P\/E (', :float],
      :PEG_Ratio => ['PEG Ratio \(5 yr expected\)', :float],
      :Price_to_Sales => ['Price\/Sales \(ttm\)', :float]
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
        if key.text.match(/^"#{AVL_KEY_STATS[key_stat][0]}"/)
          return @page_values[i]
        end
      end
      return nil
    end
  
    def key_stats_available
      return AVL_KEY_STATS.keys;
    end
  end
end