require "rubygems"
require "tire"

def search_limited(nb=15)
  s=Tire.search do
    query { string "nodename:*" }
    #  sort { by "start_time", 'desc' }
  end

  return s.results
end
