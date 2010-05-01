module Sonia
  module Helpers
    def widget_javascripts
      Dir[Sonia.root + "/widgets/*/*.js"].map do |file|
        widget_name = File.basename(file, ".js")
        file.gsub(File.join(Sonia.root, "widgets"), "/javascripts")
      end
    end

    def widget_stylesheets
      Dir[Sonia.root + "/widgets/*/*.css"].map do |file|
        widget_name = File.basename(file, ".css")
        file.gsub(File.join(Sonia.root, "widgets"), "/stylesheets")
      end
    end
  end
end
