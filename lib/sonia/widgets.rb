require 'active_support/inflector'

module Sonia
  module Widgets
    Dir[File.join(Sonia.root, "/widgets/*/*.rb")].each do |file|
      autoload File.basename(file, '.rb').classify.to_sym, file
    end
  end
end
