require "yajl"
require "digest/sha1"

module Sonia
  class Widget
    attr_reader :widget_id, :channel, :sid, :config

    def self.encoder
      @encoder ||= Yajl::Encoder.new
    end

    def self.decoder
      @decoder ||= Yajl::Parser.new
    end

    def initialize(config)
      @channel   = EM::Channel.new
      @config    = config || {}
      @widget_id = Digest::SHA1.hexdigest([@channel, @config, Time.now.usec, self.class].join)
    end

    def subscribe!(websocket)
      @sid = channel.subscribe { |msg| websocket.send msg }
    end

    def unsubscribe!
      channel.unsubscribe(sid)
    end

    def push(msg)
      payload = { :payload => msg, :widget => self.widget_name, :widget_id => self.widget_id }

      channel.push self.class.encoder.encode({ :message => payload })
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
