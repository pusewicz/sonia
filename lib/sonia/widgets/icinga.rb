require 'httparty'
require 'nokogiri'

module Sonia
  module Widgets
    class Icinga < Sonia::Widget

      def initial_push
        fetch_data
        EventMachine::add_periodic_timer(150) { fetch_data }
      end

      def format_status(stat)
        {
          :count  => stat.match(/(\d*)\s(\w*)/)[1],
          :status => stat.match(/(\d*)\s(\w*)/)[2]
        }
      end

      private
      
      def fetch_data
        statuses = Nokogiri::HTML(HTTParty.get(config[:url], {:basic_auth => {:username => config[:username], :password => config[:password]}}).to_s).xpath("//td/a[contains(@class,'serviceHeader')]").map do |node|
          format_status(node.content)
        end
        push statuses
      end
      
    end # class
  end # module
end # module