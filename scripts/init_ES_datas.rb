require "rubygems"
require "tire"

Tire.index "chef_reports" do
  delete
  
  create :mappings => {
    :chef_reports => {
      :properties => {
        :nodename => { :type => "string" },
        :elapsed_time => { :type => "double" },
        :start_time => { :type => "date", :format => "yyyy-MM-dd HH:mm:ss" },
        :end_time => { :type => "date", :format => "yyyy-MM-dd HH:mm:ss" },
        :updated_resources => { :type => "string" },
        :diffs => { :type => "string" },
      }
    }
  
  }

end
