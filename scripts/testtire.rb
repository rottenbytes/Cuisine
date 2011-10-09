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
  query { string "nodename:*" }
  sort { by :start_time, "desc" }
  size 5
end


x=s.results.map { |rslt| rslt.to_hash }

puts x.inspect
