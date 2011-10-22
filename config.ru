#!/usr/bin/env ruby

$: << File.expand_path(File.dirname(__FILE__))

require 'cuisine'
run Sinatra::Application
