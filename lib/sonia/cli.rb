require 'thor'
require "launchy"

module Sonia
  class CLI < Thor
    # namespace nil

    desc "start", "Start Sonia server"
    method_option :config, :type => :string, :aliases => "-c", :required => true
    def start
      require "sonia"
      Sonia::Server.run!(Config.new(options)) do
        Launchy::Browser.run(Sonia::Server.webserver_url)
      end
    end

    desc "console", "Start Sonia console"
    def console
      ARGV.pop # Remove console as parameter
      require 'irb'
      require 'irb/completion'
      require 'sonia'
      IRB.start(__FILE__)
    end
  end
end
