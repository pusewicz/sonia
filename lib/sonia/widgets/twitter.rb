require 'twitter/json_stream'
require 'json'

module Sonia
  module Widgets
    class Twitter < Sonia::Widget
      def initialize(username, password)
        super()

        @twitter = ::Twitter::JSONStream.connect(
          :path => '/1/statuses/filter.json?track=fuck',
          :auth => "#{username}:#{password}"
        )

        @twitter.each_item do |status|
          status = JSON.parse(status)
          msg = "#{status['user']['screen_name']}: #{status['text']}"
          push msg
        end
      end
    end
  end
end
