require "eventmachine"
require "em-websocket"

module Sonia
  module Server
    extend self

    def run!
      abort "#{self.class.name}: No username and password provided" unless ARGV[0] && ARGV[1]

      EventMachine.run {
        @channel = EM::Channel.new
        @twitter = Sonia::Widgets::Twitter.new(ARGV[0], ARGV[1])

        @widgets = [@twitter]

        EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080, :debug => true) do |ws|
          ws.onopen    {
            @sid = @channel.subscribe { |msg| ws.send msg }
            @widgets.map { |widget| widget.subscribe!(ws) }
            # @widgets.each_with_index { |widget, i| widget.push "# connected!" }
            # TODO: Push configuration to the client here
            @channel.push '{"setup":{"widget":"Twitter","payload":{"a":1}}}'
          }

          ws.onmessage { |msg|
            @widgets.each do |widget|
              widget.push "<#{@sids}>: #{msg}"
            end
          }

          ws.onclose {
            @widgets.each { |widget| widget.unsubscribe! }
            @channel.unsubscribe(@sid)
          }
        end

        puts "WebSocket Server running"
      }
    end
  end
end
