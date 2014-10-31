require 'open-uri'
require 'nokogiri'

module YahooFinance
  module IncomeStatement
    AVL_KEY_STATS = {
      :mean_recommendation_this_week => ['Mean Recommendation (this week):', "Mean Recommendation (this week):"]
    }
    def IncomeStatement.key_events_available 
      return AVL_KEY_STATS.keys;
    end

    class IncomeStatementPage
      attr_accessor :symbol
    
      def initialize symbol=nil
        @symbol = symbol
      end
      
      def fetch
        url = "http://finance.yahoo.com/q/ao?s=#{@symbol}"
        open(url) do |stream|
          @doc = Nokogiri::HTML(stream)
        end
      end
       
      def value_for key_stat
        begin
        end
        return nil
      end  
    end
  end
end