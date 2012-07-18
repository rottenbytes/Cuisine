#!/usr/bin/env ruby

require "rubygems"
require "stomp"
require "json"
require "base64"
require "time"
require "yaml"
require "cuisine/config"
require "pg"
require "json"

config=load_config("config/cuisine.yml")

debug=true

cnx=Stomp::Client.new(config["stomp_user"], config["stomp_password"], config["stomp_host"], config["stomp_port"], true)
conn = PG.connect(:host => "127.0.0.1", :dbname => "chefreports")
conn.prepare("insert_run", "INSERT INTO chefruns (nodename, elapsed_time, start_time, end_time, updated_resources, environment, diffs) VALUES ($1, $2, $3, $4, $5, $6, $7); ")


cnx.subscribe(config["stomp_queue"], { :ack => :client }) do |data|
  infos=Marshal.load(Base64.decode64(data.body))
  puts infos.inspect if config["debug"]
  # Insert into pg
  conn.exec_prepared("insert_run",[ infos[:nodename], infos[:elapsed_time], infos[:start_time].strftime("%Y/%m/%d %H:%M:%S"), infos[:end_time].strftime("%Y/%m/%d %H:%M:%S"), infos[:updated_resources].to_json, infos[:environment], infos[:diffs] ] )

  cnx.acknowledge data

end

puts cnx.inspect if config["debug"]

cnx.join
cnx.close
