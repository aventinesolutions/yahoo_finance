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
      :upgrades_downgrades_history => ["", 'Upgrades/Downgrades History'],
      :recommendation_trends => ["", "Recommendation Trends"]
    }
    def AnalystOpinion.key_events_available 
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
          elsif key_stat == :upgrades_downgrades_history
            ret = []
            tbl = @doc.xpath("//th[text() = 'Upgrades & Downgrades History']")[0].parent.parent.parent.children[1].xpath("tr")
            for i in 1..(tbl.size-1) do
              r = {}
              r[:date] = YahooFinance.parse_yahoo_field(tbl[i].children[0].text)
              r[:firm] = tbl[i].children[1].text
              r[:action] = tbl[i].children[2].text
              r[:from]  = tbl[i].children[3].text
              r[:to] = tbl[i].children[4].text
              ret << r
            end
            return ret
          elsif key_stat == :recommendation_trends
            ret = {}
            puts "DOC IS #{@doc}"
            tbl1 = @doc.xpath("//th[text() = 'Recommendation Trends']")[0].parent.parent
            puts "TABLE IS #{tbl1.to_s}"
            elem = tbl1.parent
            sibling_idx = elem.children.index(tbl1)+1
            sibling = elem.children[sibling_idx]
            puts "SIBLING IS #{sibling.to_s}"
            # now get all the subnodes...
            table_rows = sibling.xpath(".//table//tr")  # really contained within a subtable
            for i in 1..(table_rows.size-1) do
              r = table_rows[i]
              puts "GOT ROW #{r.text}"
              header = r.xpath(".//th")
              symbol = header[0].text.gsub(' ','').to_sym
              puts "GOT MY SYMBOL: #{symbol.to_s}"
              cells = r.xpath(".//td")
              ar = []
              cells.each do |cell|
                begin
                  ar << YahooFinance.parse_yahoo_field(cell.text)
                rescue
                  puts " COULD NOT PARSE NUMERIC TREND CELL"
                  ar << " "
                end
              end
              ret[symbol] = ar
              # THIS IS NOT WORKING YET. THE LOGIC IS FALSE
            end
            return ret
          end
        rescue
          puts "EXCEPTION"
        end
        return nil
      end  
    end
  end
end