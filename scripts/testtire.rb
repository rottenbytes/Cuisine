require "rubygems"
require "tire"


s=Tire.search do
  query { string "nodename:*" }
  sort { by "start_time", 'desc' }
  
end

puts s.results.count
