require "rubygems"
require "tire"

s=Tire.index "chef_reports" do
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
