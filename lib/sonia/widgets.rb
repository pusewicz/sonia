module Sonia
  module Widgets
    #Dir[File.join(File.dirname(__FILE__), "widgets/*.rb")].each do |file|
      #widget = File.basename(file, ".rb")
      #symbol = ""
    #end
    autoload :Twitter, "sonia/widgets/twitter"
    autoload :Tfl,     "sonia/widgets/tfl"
  end
end
