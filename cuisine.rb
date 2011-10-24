#!/usr/bin/env ruby

require "rubygems"
require "sinatra"
require "haml"

require "tire"
require "cuisine/elasticsearch"
require "cuisine/config"

__DIR__ = File.expand_path(File.dirname(__FILE__))

set :public, __DIR__ + '/public'
set :views,  __DIR__ + '/templates'

template :layout do
  File.read('templates/layout.haml')
end

before do
  @config=load_config("config/cuisine.yml")
end

get "/" do
  updatedonly=false
  if params[:updatedonly] == "true" then
    updatedonly=true
  end
  @latest = es_search_limited(nb=@config["homepage_hosts"],hostname=@config["homepage_filter"],filter_updated=updatedonly)
  haml :index
end

get "/search" do
  haml :search
end

post "/search" do
  criterias = {}
  criterias[:string] = {}
  criterias[:updatedonly] = false

  if params[:chk_nodename]
    criterias[:string][:nodename] = params[:nodename]
  end

  if params[:chk_updated_resources]
    criterias[:string][:updated_resources] = params[:updated_resources]
  end

  if params[:chk_diffs]
    criterias[:string][:diffs] = params[:diffs]
  end

  if params[:chk_updatedonly]
    criterias[:updatedonly] = true
  end

  @search_params=criterias
  @results = es_search_criterias(criterias=criterias)
  haml :search
end

get "/about" do
  haml :about
end

get "/host/:hostname" do
  @infos = es_search_limited(nb=@config["results_hosts"], hostname=params[:hostname])
  haml :host
end

get "/run/:id" do
  @infos = es_get_run(params[:id])[0]
  haml :run
end
