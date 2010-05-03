module Sonia
  # Responsible for just namespacing widgets
  module Widgets
    Dir[File.join(Sonia.root, "/widgets/*/*.rb")].each do |file|
      #autoload File.basename(file, '.rb').classify.to_sym, file
      require file
    end
  end
end
