require 'twitter/json_stream'
require 'yajl'

module Sonia
  module Widgets
    class Twitter < Sonia::Widget
      def initialize( config )
        super( config )

        puts "/1/statuses/filter.json?follow=#{config[:follow]}"

        @twitter = ::Twitter::JSONStream.connect(
          :path => "/1/statuses/filter.json?follow=#{config[:follow]}",
          :auth => "#{config[:username]}:#{config[:password]}"
        )

        @twitter.each_item do |status|
          #msg = "#{status['user']['screen_name']}: #{status['text']}"
          # puts status
          # push format_status(self.class.decoder.parse(status))
          push format_status(Yajl::Parser.parse(status))
        end
      end

#       {
#         "in_reply_to_status_id":11025304529,
#         "text":"@weembow LOL 'I HATE EVERYTHING BUT ANGELA AND WEED' when the fuck did i do that hahahaha",
#         "place":null,
#         "in_reply_to_user_id":26580764,
#         "source":"web",
#         "coordinates":null,
#         "favorited":false,
#         "contributors":null,
#         "geo":null,
#         "user":{
#           "lang":"en",
#           "profile_background_tile":true,
#           "location":"minneapolis minnesota",
#           "following":null,
#           "profile_sidebar_border_color":"0d0d0d",
#           "profile_image_url":"http://a1.twimg.com/profile_images/734139740/26461_106304702728342_100000464390009_157589_7540067_n_normal.jpg",
#           "verified":false,
#           "geo_enabled":true,
#           "followers_count":56,
#           "friends_count":66,
#           "description":"SCUM FUCK EAT SHIT.",
#           "screen_name":"jewslaya",
#           "profile_background_color":"cadbba",
#           "url":"http://www.facebook.com/profile.php?ref=profile&id=100000464390009",
#           "favourites_count":0,
#           "profile_text_color":"262626",
#           "time_zone":"Central Time (US & Canada)",
#           "protected":false,
#           "statuses_count":3394,
#           "notifications":null,
#           "profile_link_color":"a61414",
#           "name":"delaney pain",
#           "profile_background_image_url":
#           "http://a1.twimg.com/profile_background_images/80655374/2370378327_10f7b17053_o.jpg",          "created_at":"Tue Jul 21 18:18:40 +0000 2009",
#           "id":58872581,
#           "contributors_enabled":false,
#           "utc_offset":-21600,
#           "profile_sidebar_fill_color":"f5e180"
#          },
#         "in_reply_to_screen_name":"weembow",
#         "id":11046874752,
#         "created_at":"Thu Mar 25 18:22:14 +0000 2010",
#         "truncated":false
#       }


      def format_status( status )
        {
          :text   => status['text'],
          :user   => status['user']['screen_name'],
          :profile_image_url => status['user']['profile_image_url']
        }
      end
    end
  end
end
