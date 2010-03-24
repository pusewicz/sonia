require 'twitter/json_stream'
require 'json'

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
          status = JSON.parse(status)
          push format_status( status )
        end
      end

      def format_status( status )
        { :message => {
            :widget => :twitter,
            :text   => status['text'],
            :user   => status['user']['screen_name'] 
          }
        }.to_json
      end

      def setup
        { :Twitter => {
            :nitems => @config[:nitems],
            :title => @config[:title]
          }
        }
      end
    end
  end
end
