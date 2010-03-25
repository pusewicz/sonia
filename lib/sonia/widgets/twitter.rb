require 'twitter/json_stream'
require 'yajl'

module Sonia
  module Widgets
    class Twitter < Sonia::Widget
      def initialize( config )
        super( config )

        @twitter = ::Twitter::JSONStream.connect(
          :path => "/1/statuses/filter.json?track=#{config[:track]}",
          :auth => "#{config[:username]}:#{config[:password]}"
        )

        @twitter.each_item do |status|
          #msg = "#{status['user']['screen_name']}: #{status['text']}"
          # puts status
          # push format_status(self.class.decoder.parse(status))
          push format_status(Yajl::Parser.parse(status))
        end
      end

      def format_status( status )
        {
          :widget => self.widget_name,
          :text   => status['text'],
          :user   => status['user']['screen_name'] 
        }
      end

      def setup
          {
            :widget => self.widget_name,
            :config => {
              :nitems => config[:nitems],
              :title  => config[:title]
            }
          }
      end
    end
  end
end
