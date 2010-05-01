module Sonia
  module Helpers
    def widget_javascripts
      Dir[Sonia.root + "/public/javascripts/widgets/*.js"].map { |d| d.split("public").last }
    end
  end
end
