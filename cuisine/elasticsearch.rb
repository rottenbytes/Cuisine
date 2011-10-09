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


def es_search_criterias(criterias, nb=100)
  str_args=[]
  criterias[:string].each_pair { |k,v| str_args.push "#{k}:#{v}" }

  str_query=str_args.join(" AND ")
  
  s=Tire.search do
    query { string str_query }
    sort { by :start_time, 'desc' }
    size nb
  end
  
  return s.results.map { |rslt| rslt.to_hash }

end
