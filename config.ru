#!/usr/bin/env ruby

require 'pathname'
$: << File.expand_path(File.dirname(__FILE__))
@root = Pathname.new(File.expand_path(File.join(File.dirname(__FILE__))))
require @root.join('cuisine')

require 'cuisine'
run Sinatra::Application
