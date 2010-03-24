require "yajl"

module Sonia
  class Widget
    attr_reader :channel, :sid

    def self.encoder
      @encoder ||= Yajl::Encoder.new
    end

    def initialize
      @channel = EM::Channel.new
    end

    def subscribe!(websocket)
      @sid = channel.subscribe { |msg| websocket.send msg }
    end

    def unsubscribe!
      channel.unsubscribe(sid)
    end

    def push(msg)
      payload = { "widget" => self.class.name.split("::").last, "payload" => msg }

      channel.push self.class.encoder.encode({ "message" => payload })
    end
  end
end
