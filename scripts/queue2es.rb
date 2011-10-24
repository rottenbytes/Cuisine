#!/usr/bin/env ruby

require "rubygems"
require "stomp"
require "json"
require "base64"
require "time"
require "tire"
require "yaml"
require "cuisine/config"

config=load_config("config/cuisine.yml")

debug=true

cnx=Stomp::Client.new(config["stomp_user"], config["stomp_password"], config["stomp_host"], config["stomp_port"], true)
Tire::Configuration.url(config["es_url"])

cnx.subscribe(config["stomp_queue"], { :ack => :client }) do |data|
  infos=Marshal.load(Base64.decode64(data.body))
  puts infos.inspect if config["debug"]
  # Insert into elasticsearch
  Tire.index config["es_index"] do
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

puts cnx.inspect if config["debug"]

cnx.join
cnx.close
