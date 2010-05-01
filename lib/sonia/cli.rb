require "sonia"
require 'thor'
require "launchy"

module Sonia
  class CLI < Thor
    # namespace nil

    desc "start", "Start Sonia server"
    method_option :config, :type => :string, :aliases => "-c", :required => true
    def start
      Sonia::Server.run!(Config.new(options)) do
        Launchy::Browser.run(Sonia::Server.webserver_url)
      end
    end
  end
end
