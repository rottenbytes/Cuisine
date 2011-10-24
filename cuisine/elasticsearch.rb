require "rubygems"
require "tire"

def map2hash(s)
  rslt=s.results.map { |rslt| rslt.to_hash }

  # turn the diff into a hash
  for i in 0..rslt.count-1 do
    rslt_hash = {}
    rslt[i][:diffs].each { |elt| rslt_hash[elt[0]] = elt[1] }
    rslt[i][:diffs]=rslt_hash
  end

  return rslt
end

def es_search_limited(nb=15, hostname="*",filter_updated=false)
  if hostname == "*" then
    query_str="nodename:*"
  else
    query_str='nodename:"'+hostname+'"'
  end

  s=Tire.search do
    query { string query_str }
    sort { by :start_time, 'desc' }
    if filter_updated then
      filter :exists, :field => "updated_resources"
    end
    size nb
  end

  map2hash(s)
end


def es_search_criterias(criterias, nb=100)
  str_args=[]
  criterias[:string].each_pair { |k,v|
    # do we have a wildcard ? change ES syntax
    if v.include?("*") then
      src_arg = k.to_s+':'+v.to_s
    else
      src_arg = k.to_s+':"'+v.to_s+'"'
    end

    str_args.push src_arg
  }

  str_query=str_args.join(" AND ")

  s=Tire.search do
    query { string str_query }
    sort { by :start_time, 'desc' }
    if criterias[:updatedonly] then
      filter :exists, :field => "updated_resources"
    end

    size nb
  end

  map2hash(s)
end

def es_get_run(run_id)
  s=Tire.search do
    query do
      ids [ run_id ], "document"
    end
  end

  map2hash(s)
end
