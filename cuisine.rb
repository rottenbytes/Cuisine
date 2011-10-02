#!/usr/bin/env ruby

require "rubygems"
require "sinatra"
require "tire"

def latest_runs(nb)
  s=Tire.search do
    filter :limit => "value" => nb
  end
  
  return s
end



get "/" do
  x=latest_runs(3)
  puts x.inspect

end
