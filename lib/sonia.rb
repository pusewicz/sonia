$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

require 'logger'
require 'active_support'

module Sonia
  autoload :Server,    'sonia/server'
  autoload :Widget,    'sonia/widget'
  autoload :Widgets,   'sonia/widgets'
  autoload :WebServer, 'sonia/web_server'
  autoload :Config,    'sonia/config'
  autoload :Helpers,   'sonia/helpers'

  def self.log
    @logger ||= Logger.new(STDOUT)
  end

  def self.root
    @@root ||= File.expand_path(File.join(File.dirname(__FILE__), '..'))
  end
end
