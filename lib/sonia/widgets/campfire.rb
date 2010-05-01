require 'twitter/json_stream'
require 'uri'
require 'digest/md5'

module Sonia
  module Widgets
    class Campfire < Sonia::Widget
      GRAVATAR_URL = "http://www.gravatar.com/avatar/"
      TRANSCRIPT_URL = "%s/room/%s/transcript.json"

      attr_reader :room_uri

      def initialize(config)
        super(config)
        @users    = {}
        @room_uri = URI.encode("#{config.url}/room/#{config.room_id}.json")

        user_info
        connect_to_stream

        EventMachine::add_periodic_timer(150) { user_info }
      end

      def initial_push
        log_info "Polling `#{transcript_url}'"
        http = EventMachine::HttpRequest.new(transcript_url).get(headers)
        http.errback { log_fatal_error(http) }
        http.callback {
          handle_initial_response(http)
        }
      end

      private
      def connect_to_stream
        @stream = ::Twitter::JSONStream.connect(
          :path => "/room/#{config.room_id}/live.json",
          :host => 'streaming.campfirenow.com',
          :auth => "#{config.token}:x"
          )

        @stream.each_item do |message|
          json_message = parse_json(message)
          formatted = format_message(json_message)
          push formatted unless formatted.nil?
        end
      ensure
        log_info "Connected to stream #{@stream.inspect}"
      end

      def handle_initial_response(http)
        if http.response_header.status == 200
          messages = parse_json(http.response)["messages"].select { |message| message["type"] == "TextMessage" }
          message_from = messages.size >= config.nitems ? messages.size - config.nitems : 0
          messages[message_from..-1].each do |message|
            formatted = format_message(message)
            push formatted unless formatted.nil?
          end
        else
          log_unsuccessful_response_body(http.response)
        end
      rescue => e
        log_backtrace(e)
      end

      def format_message(message)
        if message['type'] == 'TextMessage'
          user = @users[message['user_id']]
          img = user.nil? ? '' : user_gravatar(user[:email])
          name = user.nil? ? 'Unknown' : user[:name]
          return {
            :body   => message['body'],
            :user   => name,
            :avatar => img
          }
        end
        return nil
      end

      def user_info
        log_info "Polling `#{room_uri}'"
        http = EventMachine::HttpRequest.new(room_uri).get(headers)
        http.errback { log_fatal_error(http) }
        http.callback {
          handle_user_info_response(http)
        }
      end

      def handle_user_info_response(http)
        if http.response_header.status == 200
          parse_json(http.response)['room']['users'].each do |user|
            @users[user['id']] = {
              :name  => user['name'],
              :email => user['email_address']
            }
          end
        else
          log_unsuccessful_response_body(http.response)
        end
      rescue => e
        log_backtrace(e)
      end

      def user_gravatar(email)
        email_digest = Digest::MD5.hexdigest(email)
        "#{GRAVATAR_URL}#{email_digest}?d=identicon"
      end

      def transcript_url
        TRANSCRIPT_URL % [config.url, config.room_id]
      end

      def headers
        { :head => { 'Authorization' => [config.token, "x"] } }
      end
    end
  end
end
