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

    def joined_system_javascript
      files = %w(
        /javascripts/swfobject.js
        /javascripts/FABridge.js
        /javascripts/web_socket.js
        /javascripts/json2.js
        /javascripts/prototype.js
        /javascripts/effects.js
        /javascripts/dragdrop.js
        /javascripts/livepipe.js
        /javascripts/window.js
        /javascripts/resizable.js
        /javascripts/cookie.js
        /javascripts/storage.js
        /javascripts/sonia.js
        /javascripts/dispatcher.js
        /javascripts/widget.js
      )

      joined_javascript files.map { |file| File.join(Sonia.root, "public", file) }
    end

    def joined_system_css
      files = %w(
        /blueprint/reset.css
        /blueprint/grid.css
        /stylesheets/sonia.css
      )

      joined_css files.map { |file| File.join(Sonia.root, "public", file) }
    end

    def joined_widget_javascript
      joined_javascript Dir[Sonia.root + "/widgets/*/*.js"]
    end

    def joined_widget_css
      joined_javascript Dir[Sonia.root + "/widgets/*/*.css"]
    end

    def init_javascript
      File.read(File.join(Sonia.root, "public", "javascripts", "init.js"))
    end

    private
    def joined_javascript(files)
      javascript = ""

      files.each do |file|
        javascript += "/** #{file} **/\n"
        javascript += File.read(file)
      end

      javascript
    end
    alias_method :joined_css, :joined_javascript
  end
end
