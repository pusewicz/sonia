require "eventmachine"
require "em-websocket"
require "yajl"
require "configliere"

Settings.use :commandline, :config_file

module Sonia
  module Server
    extend self

    def run!(options)
      configure(options)
      serve
    end

    def config
      @@config
    end

    def configure(options)
      @@config = Settings.read(File.expand_path(options.config))
      Settings.resolve!
      @@config
    end

    def serve
      EventMachine.run {

        @widgets = []

        config.each do |widget, config|
          class_name = "Sonia::Widgets::#{widget.to_s}"
          @widgets << module_eval(class_name).new(config)
        end

        EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080, :debug => true) do |ws|
          ws.onopen {
            @widgets.map { |widget| widget.subscribe!(ws) }

            ws.send Yajl::Encoder.encode({ :setup => @widgets.map { |widget| widget.setup } })

            @widgets.each { |widget| widget.initial_push }
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
