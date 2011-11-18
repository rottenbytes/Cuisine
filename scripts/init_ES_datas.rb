require "rubygems"
require "tire"
require "cuisine/config"

@config=load_config("config/cuisine.yml")
Tire::Configuration.url(@config["es_url"])

s=Tire.index @config["es_index"] do
  delete

  create :mappings => {
    :chef_reports => {
      :properties => {
        :nodename => { :type => "string", :dynamic => "strict" },
        :elapsed_time => { :type => "double", :dynamic => "strict" },
        :start_time => { :type => "date", :format => "yyyy-MM-dd HH:mm:ss", :dynamic => "strict" },
        :end_time => { :type => "date", :format => "yyyy-MM-dd HH:mm:ss", :dynamic => "strict" },
        :updated_resources => { :type => "string", :dynamic => "strict" },
        :diffs => { :type => "string", :dynamic => "strict" },
      }
    }

  }

end

puts s.inspect
