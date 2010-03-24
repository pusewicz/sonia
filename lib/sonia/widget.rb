module Sonia
  class Widget
    attr_reader :channel, :sid, :config

    def initialize( config )
      @channel = EM::Channel.new
      @config = config
    end

    def subscribe!(websocket)
      @sid = channel.subscribe { |msg| websocket.send msg }
    end

    def unsubscribe!
      channel.unsubscribe(sid)
    end

    def push(msg)
      msg = "#{self.class.name}: #{msg}"

      channel.push msg
    end
  end
end
