require "eventmachine"
require "em-websocket"
require "yajl"

module Sonia
  module Server
    extend self

    @@conf = {
      "Twitter" => {
        :title  => "Fuck yeah",
        :nitems => 5,
        :username => "ssuperawesom",
        :password => "tooobvious",
        :track => "obama"
      }
    }

    def run!
      EventMachine.run {

        @widgets = []

        @@conf.each_pair do | k, v |
          class_name = "Sonia::Widgets::#{k.to_s}"
          @widgets << module_eval( class_name ).new( v )
        end

        EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080, :debug => true) do |ws|
          ws.onopen    {
            @widgets.map { |widget| widget.subscribe!(ws) }

            # TODO: Push configuration to the client here
            ws.send Yajl::Encoder.encode({ :setup => @widgets.map { |widget| widget.setup } })
          }

          ws.onmessage { |msg|
            @widgets.each do |widget|
              widget.push "<#{@sids}>: #{msg}"
            end
          }

          ws.onclose {
            @widgets.each { |widget| widget.unsubscribe! }
          }
        end

        puts "WebSocket Server running"
      }
    end
  end
end
