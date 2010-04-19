require 'yajl'
require 'httparty'

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
        lines = Yajl::Parser.parse(HTTParty.get(config[:url]).to_s)["response"]["lines"].map do |line|
           format_lines(line)
        end

        push lines
      end
    end
  end
end
