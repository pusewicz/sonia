module Sonia
  module Helpers
    # Returns all available widgets with relative path recognized by the webserver
    #
    # @return [Array] Array of relalive widget Javascript paths
    def widget_javascripts
      Dir[Sonia.root + "/widgets/*/*.js"].map do |file|
        widget_name = File.basename(file, ".js")
        file.gsub(File.join(Sonia.root, "widgets"), "/javascripts")
      end
    end

    # Returns all available widget stylesheets with relative paths recognized by the webserver
    #
    # @return [Array] Array of relative widget CSS files
    def widget_stylesheets
      Dir[Sonia.root + "/widgets/*/*.css"].map do |file|
        widget_name = File.basename(file, ".css")
        file.gsub(File.join(Sonia.root, "widgets"), "/stylesheets")
      end
    end

    def websocket_host
      Sonia::Server.websocket_host
    end

    def websocket_port
      Sonia::Server.websocket_port
    end

    def websocket_url
      Sonia::Server.websocket_url
    end

    def system_javascripts
      %w(
        /vendor/swfobject.js
        /vendor/console.js
        /vendor/FABridge.js
        /vendor/web_socket.js
        /vendor/json2.js
        /vendor/prototype.js
        /vendor/effects.js
        /vendor/dragdrop.js
        /vendor/livepipe.js
        /vendor/window.js
        /vendor/resizable.js
        /vendor/cookie.js
        /javascripts/storage.js
        /javascripts/sonia.js
        /javascripts/dispatcher.js
        /javascripts/widget.js
      )
    end

    def system_stylesheets
      %w(
        /blueprint/reset.css
        /blueprint/grid.css
        /stylesheets/sonia.css
      )
    end
  end
end
