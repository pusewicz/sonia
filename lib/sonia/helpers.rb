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
  end
end
