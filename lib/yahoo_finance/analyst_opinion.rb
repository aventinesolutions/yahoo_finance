require 'open-uri'
require 'nokogiri'

module YahooFinance
  module AnalystOpinion
    AVL_KEY_STATS = {
      :mean_recommendation_this_week => ['Mean Recommendation (this week):', "Mean Recommendation (this week):"],
      :mean_recommendation_last_week => ['Mean Recommendation (last week):', "Mean Recommendation (last week):"],
      :price_target_mean => ['Mean Target:', 'Mean Price Target'],
      :price_target_median => ['Median Target:', 'Meadian Price Target'],
      :price_target_high => ['High Target:', 'High Price Target'],
      :price_target_low => ['Low Target:', 'Low Price Target'],
      :brokers_count => ['No. of Brokers:', 'Number of Brokers with recommendations'],
      :upgrades_downgrades_history => ["", 'Upgrades/Downgrades History']
    }
    def CompanyEvents.key_events_available 
      return AVL_KEY_STATS.keys;
    end

    class AnalystOpinionPage
      @symbol
    
      def initialize symbol
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
          if key_stat != :upgrades_downgrades_history
            value = @doc.xpath("//td[text() = '#{AVL_KEY_STATS[key_stat][0]}']")[0].parent.children[1].text
            return YahooFinance.parse_yahoo_field(value)
          end
        rescue
        end
        return nil
      end  
    end
  end
end