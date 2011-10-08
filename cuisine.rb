#!/usr/bin/env ruby

require "rubygems"
require "sinatra"
require "tire"
require "cuisine/elasticsearch"

__DIR__ = File.expand_path(File.dirname(__FILE__))

set :public, __DIR__ + '/public'
set :views,  __DIR__ + '/templates'

template :layout do 
  File.read('templates/layout.haml')
end


get "/" do
  #@latest = search_limited(15)
  #puts @latest.inspect
  haml :index
end

get "/search" do
  haml :search
end

get "/about" do
  haml :about
end
