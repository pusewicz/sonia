require 'nokogiri'
require 'em-http'

module Sonia
  module Widgets
    class Icinga < Sonia::Widget

      def initialize(config)
        super(config)
        EventMachine::add_periodic_timer(60) { fetch_data }
      end

      def initial_push
        fetch_data
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
        log.info(widget_name) { "Polling `#{service_url}'" }
        http = EventMachine::HttpRequest.new(service_url).get(headers)
        http.errback { log_fatal_error(http) }
        http.callback {
          handle_fetch_data_response(http)
        }
      end

      def handle_fetch_data_response(http)
        if http.response_header.status == 200
          statuses = Nokogiri::HTML(http.response).xpath("//td/a[contains(@class,'serviceHeader')]").map do |node|
            format_status(node.content)
          end
          push statuses
        else
          log_unsuccessful_response_body(http.response)
        end
      rescue => e
        log_backtrace(e)
      end

      def service_url
        config[:url]
      end
    end # class
  end # module
end # module
