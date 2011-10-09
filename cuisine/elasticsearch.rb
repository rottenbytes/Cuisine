require "rubygems"
require "tire"

def es_search_limited(nb=15)
  s=Tire.search do
    query { string "nodename:*" }
    sort { by :start_time, 'desc' }
    size nb
  end

  return s.results.map { |rslt| rslt.to_hash }

end
