#!/usr/bin/env ruby

require "rubygems"
require "sinatra"
require "haml"

require "tire"
require "cuisine/elasticsearch"

__DIR__ = File.expand_path(File.dirname(__FILE__))

set :public, __DIR__ + '/public'
set :views,  __DIR__ + '/templates'

template :layout do 
  File.read('templates/layout.haml')
end

get "/" do
  @latest = es_search_limited(nb=5,hostname="*")
  puts @latest.inspect
  haml :index
end

get "/search" do
  haml :search
end

post "/search" do
#  puts params.inspect
  criterias = {}
  criterias[:string] = {}
  
  if params[:chk_nodename] 
    criterias[:string][:nodename] = params[:nodename]
  end
  
  if params[:chk_updated_resources] 
    criterias[:string][:updated_resources] = params[:updated_resources]
  end

  if params[:chk_diffs] 
    criterias[:string][:diffs] = params[:diffs]
  end

  @search_params=criterias  
  @results = es_search_criterias(criterias=criterias)
  haml :search
end

get "/about" do
  haml :about
end

get "/host/:hostname" do
  puts params.inspect
  @infos = es_search_limited(nb=15, hostname=params[:hostname])
  haml :host
end

get "/run/:id" do
  @infos = es_get_run(params[:id])[0]
  haml :run
end
