require 'rubygems'
require 'octopi'
#require File.join(File.dirname(__FILE__), 'octopi', 'lib', 'octopi')

module Github
  include Octopi

  MITUSER = "mitadmin"

  def self.all_repoitories
    authenticated_with :login => "wjlroe", :token => "c2004894a1bb87682c4d1a3628188a05" do 
      user = User.find("mitadmin")
      puts user
      user.repositories
    end
  end
end

puts Github.all_repoitories
