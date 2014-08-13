require 'open-uri'
require 'nokogiri'

module YahooFinance
  module CompanyProfile
    COMPANY_PROFILE_STATS = {
      :sector => ['Sector:', "Sector classification"],
      :industry => ['Industry:', 'Industry classification'],
      :website => ['Website:', 'Company website']
    }
    def CompanyProfile.key_events_available 
      return YahooFinance::CompanyProfile::COMPANY_PROFILE_STATS.keys;
    end

    class CompanyProfilePage
      @symbol
    
      def initialize symbol
        @symbol = symbol
      end
      
      def fetch
        url = "http://finance.yahoo.com/q/pr?s=#{@symbol}"
        open(url) do |stream|
          @doc = Nokogiri::HTML(stream)
        end
      end
      
      def doc
        @doc
      end
       
      def value_for key_stat
        if key_stat == :website
          r = @doc.xpath("//td[contains(., \"#{YahooFinance::CompanyProfile::COMPANY_PROFILE_STATS[key_stat][0]}\")]")
          return r.xpath("./a[contains(., 'http:')]").text
        elsif CompanyProfile::key_events_available.include? key_stat
          begin
            value = @doc.xpath("//td[text() = \"#{YahooFinance::CompanyProfile::COMPANY_PROFILE_STATS[key_stat][0]}\"]")[0].parent.children[1].text
            return value
          rescue
            return nil
          end
        else
          raise StandardError::ArgumentError, "#{key_stat.to_s} not implemented"
        end 
      end  
    end
  end
end
