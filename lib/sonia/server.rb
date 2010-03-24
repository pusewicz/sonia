require "eventmachine"
require "em-websocket"
require "json"

module Sonia
  module Server
    extend self

    @@conf = {
      :twitter => {
        :title  => "Fuck yeah",
        :nitems => 10,
        :username => "ssuperawesom",
        :password => "tooobvious",
        :track => "obama"
      }
    }

    def run!
      EventMachine.run {

        @widgets = []

        @@conf.each_pair do | k, v |
          class_name = "Sonia::Widgets::#{k.to_s.capitalize}"
          @widgets << module_eval( class_name ).new( v )
        end

        EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080, :debug => true) do |ws|
          ws.onopen    {
            @sids = @widgets.map { |widget| widget.subscribe!(ws) }
            setup = @widgets.map{ |widget| widget.setup }
            ws.send( { :setup => setup }.to_json )
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
