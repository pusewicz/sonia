require 'thor'
require "launchy"

module Sonia
  class CLI < Thor
    # namespace nil

    desc "start", "Start Sonia server"
    method_option :config, :type => :string, :aliases => "-c", :required => true
    method_option :'no-auto', :type => :boolean
    def start
      require "sonia"
      Sonia::Server.run!(Config.new(options)) do
        Launchy.open(Sonia::Server.webserver_url) unless options[:'no-auto']
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

    desc "version", "Prints Sonia's version information"
    def version
      require 'sonia/version'
      puts "Sonia v#{Sonia::VERSION}"
    end
    map %w(-v --version) => :version
  end
end
