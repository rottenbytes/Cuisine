#!/usr/bin/env ruby

require "rubygems"
require "stomp"
require "json"
require "base64"
require "time"
require "tire"

stomp_host="10.251.12.22"
stomp_user="chef"
stomp_pass="ue3Eir0a"
stomp_queue="/queue/chef"

es_url="http://127.0.0.1:9200"
es_index="chef_reports"

debug=true

cnx=Stomp::Client.new(stomp_user, stomp_pass, stomp_host, 6163, true)
Tire::Configuration.url(es_url)

cnx.subscribe(stomp_queue, { :ack => :client }) do |data|
  infos=Marshal.load(Base64.decode64(data.body))
  puts infos.inspect 
  # Insert into elasticsearch
  Tire.index es_index do
    create
    
    store :nodename => infos[:nodename], 
          :elapsed_time => infos[:elapsed_time],
          :start_time => infos[:start_time].strftime("%Y/%m/%d %H:%M:%S"),
          :end_time => infos[:end_time].strftime("%Y/%m/%d %H:%M:%S"),
          :updated_resources => infos[:updated_resources],
          :diffs => infos[:diffs]
          
    refresh
  end
  
  cnx.acknowledge data
end

puts cnx.inspect

cnx.join
cnx.close
