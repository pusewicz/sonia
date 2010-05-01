module Sonia
  module Widgets
    class Tfl < Sonia::Widget
      URL = "http://api.tubeupdates.com/?method=get.status&lines=all&format=json"

      def initialize(config)
        super(config)
        EventMachine::add_periodic_timer(150) { fetch_data }
      end

      def initial_push
        fetch_data
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
        log_info "Polling `#{service_url}'"
        http = EventMachine::HttpRequest.new(service_url).get
        http.errback { log_fatal_error(http) }
        http.callback {
          handle_fetch_data_response(http)
        }
      end

      def handle_fetch_data_response(http)
        if http.response_header.status == 200
          parse_response(http.response)
        else
          log_unsuccessful_response_body(http.response)
        end
      end

      def parse_response(response)
        lines = parse_json(response)["response"]["lines"].map do |line|
          format_lines(line)
        end
        push lines
      rescue => e
        log_backtrace(e)
      end

      def service_url
        URL
      end
    end
  end
end
