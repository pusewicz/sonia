require 'yajl'
require 'em-http'

module Sonia
  module Widgets
    class Tfl < Sonia::Widget
      def initial_push
        fetch_data
        EventMachine::add_periodic_timer(150) { fetch_data }
      end

      def format_lines(line)
        {
          :status_requested => line["status_requested"],
          :id               => line["id"],
          :name             => line["name"],
          :status           => line["status"],
          :messages         => line["messages"].join("\n")
        }
      end

      private
      def fetch_data
        http = EventMachine::HttpRequest.new(config[:url]).get
        http.callback {
          lines = Yajl::Parser.parse(http.response)["response"]["lines"].map do |line|
             format_lines(line)
          end

          push lines
        }
      end
    end
  end
end
