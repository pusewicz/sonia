require "eventmachine"
require "em-websocket"
require 'em-http'
require "yajl"
require "yaml"
require "thin"

module Sonia
  # Main Sonia event loop
  #
  # Starts both WebServer and WebSocket server
  #
  # @author Piotr Usewicz
  module Server
    extend self

    # Defaults
    WEBSOCKET_HOST = "localhost"
    WEBSOCKET_PORT = 8080

    WEBSERVER_HOST = "localhost"
    WEBSERVER_PORT = 3000

    # Starts the server
    #
    # @param [Hash] args Startup options
    def run!(args, &block)
      @start_block = block
      configure(args)
      serve
    end

    # Returns configuration from the config file
    #
    # @return [Config]
    def config
      @@config
    end

    # Loads the configuration file
    #
    # @param [Hash] options
    # @return [Config]
    def configure(options)
      @@config = Config.new(YAML.load_file(File.expand_path(options.config)))
    end

    # Returns [Logger] object
    #
    # @return [Logger]
    def log
      Sonia.log
    end

    # Starts main [EventMachine] loop
    def serve
      EventMachine.run {
        initialize_widgets
        start_web_socket_server
        start_web_server
        @start_block.call
      }
    end

    # Goes through configured widgets and initializes them
    def initialize_widgets
      @widgets = []

      config.widgets.each do |widget, config|
        class_name = "Sonia::Widgets::#{widget.to_s}"
        log.info("Server") { "Created widget #{widget} with #{config.inspect}" }
        @widgets << module_eval(class_name).new(config)
      end
    end

    # Returns websocket configuration options
    #
    # @return [Hash] Websocket's host and port number
    def websocket_options
      { :host => websocket_host, :port => websocket_port }
    end

    # Returns configured websocket hostname
    #
    # @return [String] Websocket hostname
    def websocket_host
      config.websocket.host || WEBSOCKET_HOST
    end

    # Returns configured websocket port
    #
    # @return [String] Websocket port
    def websocket_port
      config.websocket.port || WEBSOCKET_PORT
    end

    # Starts WebSocket server
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

    # Starts Thin WebServer
    def start_web_server
      Thin::Server.start(
        webserver_host,
        webserver_port,
        ::Sonia::WebServer
      )
    end

    # Returns configured webserver host
    #
    # @return [String] Webserver host
    def webserver_host
      config.webserver.host || WEBSERVER_HOST
    end

    # Returns configured webserver port
    #
    # @return [String] webserver port
    def webserver_port
      config.webserver.port || WEBSERVER_PORT
    end

    # Returns WebServer URL
    #
    # @return [String] WebServer URL
    def webserver_url
      "http://#{webserver_host}:#{webserver_port}"
    end

    # Returns WebSocket URL
    #
    # @return [String] WebSocket URL
    def websocket_url
      "ws://#{websocket_host}:#{websocket_port}"
    end
  end
end
