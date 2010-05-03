$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

require 'logger'
require 'active_support'

# @author Piotr Usewicz
module Sonia
  autoload :Server,    'sonia/server'
  autoload :Widget,    'sonia/widget'
  autoload :Widgets,   'sonia/widgets'
  autoload :WebServer, 'sonia/web_server'
  autoload :Config,    'sonia/config'
  autoload :Helpers,   'sonia/helpers'

  # Returns application logger
  #
  # @return [Logger]
  def self.log
    @logger ||= Logger.new(STDOUT)
  end

  # Returns expanded path to the root directory
  #
  # @return [String] expanded path to the root directory
  def self.root
    @@root ||= File.expand_path(File.join(File.dirname(__FILE__), '..'))
  end
end
