$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

require 'logger'

module Sonia
  autoload :Server, 'sonia/server'
  autoload :Widget, 'sonia/widget'
  autoload :Widgets, 'sonia/widgets'
  autoload :WebServer, 'sonia/web_server'
  autoload :Config, 'sonia/config'

  def self.log
    @logger ||= Logger.new(STDOUT)
  end
end
