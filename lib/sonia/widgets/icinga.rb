require 'nokogiri'
require 'em-http'

module Sonia
  module Widgets
    class Icinga < Sonia::Widget

      def initial_push
        fetch_data
        EventMachine::add_periodic_timer(61) { fetch_data }
      end

      def format_status(stat)
        {
          :count  => stat.match(/(\d*)\s(\w*)/)[1],
          :status => stat.match(/(\d*)\s(\w*)/)[2]
        }
      end

      private
      
      def headers
        { :head => { 'Authorization' => [config[:username], config[:password]] } }
      end
      
      def fetch_data
        http = EventMachine::HttpRequest.new(config[:url]).get(headers)
        http.callback {
          statuses = Nokogiri::HTML(http.response).xpath("//td/a[contains(@class,'serviceHeader')]").map do |node|
            format_status(node.content)
          end
          push statuses
        }
      end
      
    end # class
  end # module
end # module