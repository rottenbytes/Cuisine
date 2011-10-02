#!/usr/bin/env ruby

require "rubygems"
require "sinatra"
require "tire"

__DIR__ = File.expand_path(File.dirname(__FILE__))

#def latest_runs(nb)
#  s=Tire.search do
#    filter :limit => "value" => nb
#  end
#  
#  return s
#end

set :public, __DIR__ + '/public'
set :views,  __DIR__ + '/templates'

template :layout do 
  File.read('templates/layout.haml')
end


get "/" do

  haml :index
end
