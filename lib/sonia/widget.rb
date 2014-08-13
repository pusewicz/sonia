require "oj"
require "yaml"
require "nokogiri"
require "digest/sha1"

module Sonia
  # @abstract
  class Widget
    class << self
      def inherited(subclass)
        (@widgets ||= []) << subclass unless widgets.include?(subclass)
      end

      def widgets
        @widgets ||= []
      end
    end

    attr_reader :widget_id, :channel, :sid, :config, :log

    # Initalizes the widget
    #
    # @param [Hash] config Configuration of the widget from the config file
    def initialize(config)
      @log       = Sonia.log
      @channel   = EM::Channel.new
      @config    = config || Config.new({})
      @widget_id = Digest::SHA1.hexdigest([
        @config.to_hash.keys.map { |s| s.to_s }.sort.join,
        @config.to_hash.values.map { |s| s.to_s }.sort.join,
        self.class
      ].join)
    end

    # Returns JSON string
    #
    # @return [String]
    def encode_json(payload)
      Oj.dump payload
    end

    # Parses JSON
    #
    # @param [String] payload JSON string
    # @return [Hash] Parsed JSON represented as a hash
    def parse_json(payload)
      Oj.load(payload)
    end

    # Parses YAML
    #
    # @param [String] payload YAML string
    # @return [Hash] Parsed YAML represented as a hash
    def parse_yaml(payload)
      YAML.load(payload)
    end

    # Parse XML
    #
    # @param [String] payload XML string
    # @return [Nokogiri::XML::Document] Parsed Nokogiri document
    def parse_xml(payload)
      Nokogiri(payload)
    end

    # Used to push initial data after setup
    # def initial_push; end

    # Subscribes a websocket to widget's data channel
    #
    # @param [EventMachine::WebSocket] websocket
    # @return [String] Subscriber ID
    def subscribe!(websocket)
      @sid = channel.subscribe { |msg| websocket.send msg }
    ensure
      log.info(widget_name) { "Subscribed #{sid} via #{channel}" }
    end

    # Unsubscribes a subscriber id from data channel
    def unsubscribe!
      channel.unsubscribe(sid)
    ensure
      log.info(widget_name) { "Unsubscribed #{sid} via #{channel}" }
    end

    # Pushes data to the channel
    #
    # @param [Hash] msg Data which can be JSONified
    def push(msg)
      payload = {
        :payload   => msg,
        :widget    => self.widget_name,
        :widget_id => self.widget_id
      }

      message = { :message => payload }

      channel.push self.encode_json(message)
    ensure
      log.info(widget_name) { "Pushing #{message.inspect} via #{channel}" }
    end

    # Returns widget name
    #
    # @return [String] Name of the widget
    def widget_name
      self.class.name.split("::").last
    end

    # Initial widget setup data that gets pushed to the client
    #
    # @return [Hash] Initial widget information and configuration
    def setup
      {
        :widget    => self.widget_name,
        :widget_id => self.widget_id,
        :config    => self.config.to_hash
      }
    end

    def log_unsuccessful_response_body(response_body)
      log.warn(widget_name) { "Bad response: #{response_body.inspect}" }
    end

    def log_fatal_error(http)
      log.fatal(widget_name) { http.inspect }
    end

    def log_backtrace(exception)
      log.fatal(widget_name) { [exception.message, exception.backtrace].join("\n") }
    end

    def log_info(message)
      log.info(widget_name) { message }
    end
  end
end
