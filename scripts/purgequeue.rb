#!/usr/bin/env ruby

require "rubygems"
require "stomp"
require "json"
require "base64"

stomp_host="10.14.1.202"
stomp_user="chef"
stomp_pass="ue3Eir0a"
stomp_queue="/queue/chef"

debug=true

cnx=Stomp::Client.new(stomp_user, stomp_pass, stomp_host, 6163, true)

cnx.subscribe(stomp_queue, { :ack => :client }) do |data|
  infos=Marshal.load(Base64.decode64(data.body))
  puts infos.inspect 
  cnx.acknowledge data
end

puts cnx.inspect

cnx.join
cnx.close
