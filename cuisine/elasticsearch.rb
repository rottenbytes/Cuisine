require "rubygems"
require "tire"


def map2hash(s)
  rslt=s.results.map { |rslt| rslt.to_hash }

  # turn the diff into a hash
  for i in 0..rslt.count-1 do
    rslt[i][:diffs]=rslt[i][:diffs].to_hash unless rslt[i][:diffs].nil?
  end
  
  return rslt

end

def es_search_limited(nb=15)
  s=Tire.search do
    query { string "nodename:*" }
    sort { by :start_time, 'desc' }
    size nb
  end

  map2hash(s)
end


def es_search_criterias(criterias, nb=100)
  str_args=[]
  criterias[:string].each_pair { |k,v| str_args.push "#{k}:#{v}" }

  str_query=str_args.join(" AND ")
  
  s=Tire.search do
    query { string str_query }
    sort { by :start_time, 'desc' }
    size nb
  end
  
  map2hash(s)
end
