require 'active_support/inflector'

module Sonia
  module Widgets
    Dir[File.join(Sonia.root, "lib/sonia/widgets/*.rb")].each do |file|
      autoload File.basename(file, '.rb').classify.to_sym, file.gsub(Sonia.root + "/lib/", "")
    end
  end
end
