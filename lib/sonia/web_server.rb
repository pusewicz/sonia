require 'sinatra'
require 'haml'

module Sonia
  # Sonia's Web Server
  #
  # Allows dynamically generating HTML pages
  #
  # @author Piotr Usewicz
  class WebServer < Sinatra::Base
    helpers Sonia::Helpers

    set :public_dir, File.expand_path(File.dirname(__FILE__) + '/../../public')
    set :views,      File.expand_path(File.dirname(__FILE__) + '/../../views')
    set :env,        :production

    configure do
      set :haml, { :format => :html5, :attr_wrapper => %Q{"} }
    end

    get "/" do
      haml :index
    end

    get "/javascripts/:widget/*.js" do
      content_type 'application/javascript', :charset => 'utf-8'
      send_file File.join(Sonia.root, "widgets", params[:widget], params[:splat].first + ".js")
    end

    get "/stylesheets/:widget/*.css" do
      content_type 'text/css', :charset => 'utf-8'
      send_file File.join(Sonia.root, "widgets", params[:widget], params[:splat].first + ".css")
    end

    get "/images/:widget/*.*" do
      send_file File.join(Sonia.root, "widgets", params[:widget], "images", params[:splat].join('.'))
    end
  end
end
