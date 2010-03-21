module Sonia
  class Widget
    attr_reader :channel, :sid

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
      msg = "#{self.class.name}: #{msg}"

      channel.push msg
    end
  end
end
