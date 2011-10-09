require "rubygems"
require "tire"

#s2 = Tire.index "runs" do
#  create :mappings => {
#    :runs => {
#      :properties => {
#        :nodename => { :type => 'string' },
#        :start_time => { :type => 'string' },
#        :end_time => { :type => 'string' },
#      }
#    }
#  }
#end

#puts s2.inspect

s=Tire.search 'chef_reports' do
  criterias = {}
  criterias[:string] = {}
  criterias[:string][:nodename] = "*" 
  criterias[:string][:updated_resources] ="*stomp*"
  
  str_args=[]
  criterias[:string].each_pair { |k,v| str_args.push "#{k}:#{v}" }

  str_query=str_args.join(" AND ")

  query { string str_query }
  sort { by :start_time, "desc" }
  size 5
end


x=s.results.map { |rslt| rslt.to_hash }

puts x.inspect
