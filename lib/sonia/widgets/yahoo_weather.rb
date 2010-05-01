module Sonia
  module Widgets
    class YahooWeather < Sonia::Widget
      URL = "http://weather.yahooapis.com/forecastrss?w=%s&u=%s"

      def initialize(config)
        super(config)
        EventMachine::add_periodic_timer(60 * 15) { fetch_data }
      end

      def initial_push
        fetch_data
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
        payload = {}
        xml = parse_xml(response)

        location = xml.search("/rss/channel/yweather:location").first
        payload[:location] = {}

        [:city, :region, :country].each do |el|
          payload[:location][el] = location[el]
        end

        location = xml.search("/rss/channel/yweather:units").first
        payload[:units] = {}

        [:temperature, :distance, :pressure, :speed].each do |el|
          payload[:units][el] = location[el]
        end

        location = xml.search("/rss/channel/yweather:wind").first
        payload[:wind] = {}

        [:chill, :direction, :speed].each do |el|
          payload[:wind][el] = location[el]
        end

        location = xml.search("/rss/channel/yweather:atmosphere").first
        payload[:atmosphere] = {}

        [:humidity, :visibility, :pressure, :rising].each do |el|
          payload[:atmosphere][el] = location[el]
        end

        location = xml.search("/rss/channel/yweather:astronomy").first
        payload[:astronomy] = {}

        [:sunrise, :sunset].each do |el|
          payload[:astronomy][el] = location[el]
        end

        location = xml.search("/rss/channel/item/yweather:forecast")
        payload[:forecast] = []

        location.each do |element|
          [:day, :date, :low, :high, :text, :code].each do |el|
            forecast = {}
            forecast[el] = element[el]
            payload[:forecast] << forecast
          end
        end

        payload[:image] = xml.search("/rss/channel/item/description").text.match(/<img src=\"(.*)\"\/>/)[1]

        payload[:lat] = xml.search("/rss/channel/item/geo:lat").first.text
        payload[:long] = xml.search("/rss/channel/item/geo:long").first.text

        location = xml.search("/rss/channel/item/yweather:condition").first
        payload[:condition] = {}

        [:text, :code, :temp, :date].each do |el|
          payload[:condition][el] = location[el]
        end

        push payload
      rescue => e
        log_backtrace(e)
      end

      def service_url
        URL % [config.woeid, config.units == "celsius" ? "c" : "f"]
      end
    end
  end
end
