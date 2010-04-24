require "yajl"
require "digest/sha1"

module Sonia
  class Widget
    attr_reader :widget_id, :channel, :sid, :config, :log

    def initialize(config)
      @log       = Sonia.log
      @channel   = EM::Channel.new
      @config    = config || {}
      @widget_id = Digest::SHA1.hexdigest([@channel, @config, Time.now.usec, self.class].join)
    end

    def encoder
      @encoder ||= Yajl::Encoder.new
    end

    def parser
      @decoder ||= Yajl::Parser.new
    end

    def parse_json(payload)
      Yajl::Parser.parse(payload)
    end

    # Used to push initial data after setup
    #def initial_push; end

    def subscribe!(websocket)
      @sid = channel.subscribe { |msg| websocket.send msg }
    ensure
      log.info(widget_name) { "Subscribed #{sid} via #{channel}" }
    end

    def unsubscribe!
      channel.unsubscribe(sid)
    ensure
      log.info(widget_name) { "Unsubscribed #{sid} via #{channel}" }
    end

    def push(msg)
      payload = {
        :payload   => msg,
        :widget    => self.widget_name,
        :widget_id => self.widget_id
      }

      message = { :message => payload }

      channel.push self.encoder.encode(message)
    ensure
      log.info(widget_name) { "Pushing #{message.inspect} via #{channel}" }
    end

    def widget_name
      self.class.name.split("::").last
    end

    def setup
      {
        :widget    => self.widget_name,
        :widget_id => self.widget_id,
        :config    => self.config
      }
    end
  end
end
