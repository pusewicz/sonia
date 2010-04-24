require "eventmachine"
require "em-websocket"
require "yajl"
require "configliere"
require "thin"

Settings.use :commandline, :config_file

module Sonia
  module Server
    extend self

    WEBSOCKET_HOST = "0.0.0.0"
    WEBSOCKET_PORT = 8080

    WEBSERVER_HOST = "0.0.0.0"
    WEBSERVER_PORT = 3000

    def run!(options, &block)
      @start_block = block
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

    def log
      Sonia.log
    end

    def serve
      EventMachine.run {

        initialize_widgets
        start_web_socket_server
        start_web_server
        @start_block.call
      }
    end

    def initialize_widgets
      @widgets = []

      config.each do |widget, config|
        class_name = "Sonia::Widgets::#{widget.to_s}"
        log.info("Server") { "Created widget #{widget} with #{config.inspect}" }
        @widgets << module_eval(class_name).new(config)
      end
    end

    def websocket_options
      { :host => WEBSOCKET_HOST, :port => WEBSOCKET_PORT }
    end


    def start_web_socket_server
      EventMachine::WebSocket.start(websocket_options) do |ws|
        ws.onopen {
          @widgets.map { |widget| widget.subscribe!(ws) }

          setup_message = { :setup => @widgets.map { |widget| widget.setup } }
          ws.send Yajl::Encoder.encode(setup_message)

          log.info("Server") { "Sent setup #{setup_message.inspect}" }

          @widgets.each { |widget|
            if widget.respond_to?(:initial_push)
              log.info(widget.widget_name) { "Sending initial push" }
              widget.initial_push
            end
          }
        }

        #ws.onmessage { |msg|
        #@widgets.each do |widget|
        #widget.push "<#{@sids}>: #{msg}"
        #end
        #}

        ws.onclose {
          @widgets.each { |widget| widget.unsubscribe! }
        }
      end

      log.info("Server") { "WebSocket Server running at #{websocket_options[:host]}:#{websocket_options[:port]}" }
    end

    def start_web_server
      Thin::Server.start(WEBSERVER_HOST, WEBSERVER_PORT, ::Sonia::WebServer)
    end

    def webserver_url
      "http://#{WEBSERVER_HOST}:#{WEBSERVER_PORT}"
    end
  end
end
