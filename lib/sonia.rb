$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

module Sonia
  autoload :Server, 'sonia/server'
  autoload :Widget, 'sonia/widget'
  autoload :Widgets, 'sonia/widgets'
end
