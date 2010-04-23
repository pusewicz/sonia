require 'yajl'
require 'twitter/json_stream'
require 'uri'
require 'em-http'
require 'digest/md5'

module Sonia
  module Widgets
    class Campfire < Sonia::Widget
      GRAVATAR_URL = "http://www.gravatar.com/avatar/"

      def initialize(config)
        super(config)
        @room_uri = URI.encode("#{config[:url]}/room/#{config[:room_id]}.json")
        user_info
        connect_to_stream

        EventMachine::add_periodic_timer(150) { user_info }
      end
      
      # def initial_push
      #   http = EventMachine::HttpRequest.new(@room_uri).get(headers)
      #   http.callback {
      #     Yajl::Parser.parse(http.response).each_pair do |json_message|
      #       formatted = format_message(json_message)
      #       push formatted unless formatted.nil?
      #     end
      #   }
      # end

      private
      def connect_to_stream
        @stream = ::Twitter::JSONStream.connect(
          :path => "/room/#{config[:room_id]}/live.json",
          :host => 'streaming.campfirenow.com',
          :auth => "#{config[:token]}:x"
          )

        @stream.each_item do |message|
          json_message = Yajl::Parser.parse(message)
          formatted = format_message(json_message)
          push formatted unless formatted.nil?
        end
      end

      def format_message(message)
        if message['type'] == 'TextMessage'
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

      def user_info
        @users ||= {}
        http = EventMachine::HttpRequest.new(@room_uri).get(headers)
        http.callback {
          Yajl::Parser.parse(http.response)['room']['users'].each do |user|
            @users[user['id']] = {
              :name  => user['name'],
              :email => user['email_address']
            }
          end
        }
      end

      def user_gravatar(email)
        email_digest = Digest::MD5.hexdigest(email)
        "#{GRAVATAR_URL}#{email_digest}?d=identicon"
      end

      def headers
        { :head => { 'Authorization' => [config[:token], "x"] } }
      end
    end
  end
end
