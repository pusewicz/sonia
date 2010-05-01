require 'sinatra'
require 'haml'

module Sonia
  class WebServer < Sinatra::Base
    helpers Sonia::Helpers

    set :public,   File.expand_path(File.dirname(__FILE__) + '/../../public')
    set :views,    File.expand_path(File.dirname(__FILE__) + '/../../views')
    set :env,      :production

    configure do
      set :haml, { :format => :html5, :attr_wrapper => %Q{"} }
    end

    get "/" do
      haml :index
    end
  end
end
