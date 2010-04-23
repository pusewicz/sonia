require 'yajl'
require 'twitter/json_stream'
require 'uri'
require 'httparty'
require 'em-http'
require 'digest/md5'

module Sonia
  module Widgets
    class Campfire < Sonia::Widget
      GRAVATAR_URL = "http://www.gravatar.com/avatar/"
      
      def initialize(config)
        super(config)
        @room_uri = URI.encode("#{config[:url]}/room/#{config[:room_id]}.json")
        user_info()
        connect_to_stream()

        EventMachine::add_periodic_timer(150) { user_info() }
      end

      private
      def connect_to_stream
        puts "Connecting to campfire: #{config.inspect}"
        @stream = ::Twitter::JSONStream.connect(
          :path => "/room/#{config[:room_id]}/live.json",
          :host => 'streaming.campfirenow.com',
          :auth => "#{config[:token]}:x"
          )

        @stream.each_item do |message|
          json_message = Yajl::Parser.parse(message)
          puts json_message
          formatted = format_message(json_message)
          push formatted unless formatted.nil?
        end
      end

      def format_message(message)
        if message['type']=='TextMessage'
          user = @users[message['user_id']]
          img = user.nil? ? '' : user_gravatar(user[:email])
          name = user.nil? ? 'Unknown' : user[:name]
          return {
            :body => message['body'],
            :user => name,
            :avatar => img
          }
        end
        return nil
      end

      def user_info()
        puts "Getting user info"
        @users ||= {}
        room_info = HTTParty.get(@room_uri, :format => :json, :basic_auth => {:username => config[:token], :password => 'x'})
        puts room_info.inspect
        room_info['room']['users'].each do |user|
          @users[user['id']] = {
            :name => user['name'],
            :email => user['email_address']
          }
        end
        puts @users.inspect
      end

      def user_gravatar(email)
        email_digest = Digest::MD5.hexdigest(email)
        "#{GRAVATAR_URL}#{email_digest}?d=identicon"
      end
    end
  end
end
