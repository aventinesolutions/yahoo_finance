require 'open-uri'
require 'nokogiri'

module YahooFinance
  module CompanyEvents
    COMPANY_EVENTS_STATS = {
      :next_earnings_announcement_date => ['Earnings announcement', "Next earnings call date"]
    }
    def CompanyEvents.key_events_available 
      return YahooFinance::CompanyEvents::COMPANY_EVENTS_STATS.keys;
    end

    class CompanyEventsPage
      attr_accessor :symbol
    
      def initialize symbol=nil
        @symbol = symbol
      end
      
      def fetch
        url = "http://finance.yahoo.com/q/ce?s=#{@symbol}"
        open(url) do |stream|
          @doc = Nokogiri::HTML(stream)
        end
      end
       
      def value_for key_stat
        begin
          if key_stat == :next_earnings_announcement_date
            if @doc.css('table#yfncsumtab//table.yfnc_datamodoutline1//table//td.yfnc_tabledata1')[1].text == "Earnings announcement"
              return YahooFinance.parse_yahoo_field(@doc.css('table#yfncsumtab//table.yfnc_datamodoutline1//table//td.yfnc_tabledata1')[0].text)
            end
          end
        rescue
        end
        return nil
      end
  
    end
  end
end
