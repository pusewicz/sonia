module Sonia
  module Widgets
    class Foursquare < Sonia::Widget

      CHECKINS_URL = "http://api.foursquare.com/v1/checkins.json"

      def initialize(config)
        super(config)
        EventMachine::add_periodic_timer(150) { fetch_data }
      end

      def initial_push
        fetch_data
      end

      def format_checkin(checkin)
        {
          :name       => "#{checkin["user"]["firstname"]} #{checkin["user"]["lastname"]}",
          :avatar_url => checkin["user"]["photo"],
          :venue      => checkin["venue"]["name"],
          :when       => time_ago_in_words(Time.now - Time.parse(checkin["created"]))
        }
      end

      private
      def fetch_data
        log_info "Polling `#{CHECKINS_URL}'"
        http = EventMachine::HttpRequest.new(CHECKINS_URL).get(headers)
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
        messages = []
        parse_json(response)["checkins"][0..5].map do |checkin|
          messages << format_checkin(checkin) if checkin["venue"]
        end
        push messages
      rescue => e
        log_backtrace(e)
      end

      def headers
        { :head => { 'Authorization' => [config.username, config.password] } }
      end

      def time_ago_in_words(seconds)
        case seconds
        when 0..60 then "#{seconds.floor} seconds"
        when 61..3600 then "#{(seconds/60).floor} minutes"
        when 3601..86400 then "#{(seconds/3600).floor} hours"
        else "#{(seconds/86400).floor} days"
        end
      end

    end
  end
end

