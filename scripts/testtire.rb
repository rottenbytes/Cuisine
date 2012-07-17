require "rubygems"
require "tire"

def map2hash(s)
  rslt=s.results.map { |rslt| rslt.to_hash }

  # turn the diff into a hash
  for i in 0..rslt.count-1 do
    rslt_hash = {}
    rslt[i][:diffs].each { |elt| rslt_hash[elt[0]] = elt[1] }
    rslt[i][:diffs]=rslt_hash

#    rslt[i][:updated_resources] = rslt[i][:updated_resources].to_hash

  end



  return rslt
end



#s=Tire.search do
#  query do
#      ids [ "ee_301oGQ26Vrnipo0ww5g" ], "document"
#  end
#end

s=Tire.search do
  facet("environments") { terms :environment  }
end

puts s.results.facets["environments"]["terms"].inspect
puts ""
puts ""
x = {}
s.results.facets["environments"]["terms"].each do |key,value|
  x[key["term"]] = key["count"]
end

puts x.inspect
y =x.sort_by{ |k,v| -v  }
puts y.inspect

exit 0

x = map2hash(s)
puts x.inspect

x.each do |r|
  puts r[:updated_resources].class
  puts r[:updated_resources].inspect

end

exit 0

# --------------------------------------------------

s=Tire.search "chef_reports" do
  criterias = {}
  criterias[:string] = {}
  criterias[:string][:nodename] = "test1.fotolia.loc"
  criterias[:string][:updated_resources] ="*nagios*"
  criterias[:string][:diffs] = "*mem*"

  str_args=[]
  criterias[:string].each_pair { |k,v| str_args.push "#{k}:#{v}" }

  str_query=str_args.join(" AND ")

  puts "[+] string query => #{str_query}"

# query { string "nodename:vbo* AND diffs:*foo*" }
  query { string str_query }
  sort { by :start_time, "desc" }
  size 5
end


#x=s.results.map { |rslt| rslt.to_hash }

#for i in 0..x.count-1 do
#  x[i][:diffs]=x[i][:diffs].to_hash unless x[i][:diffs].nil?
#end

puts ""
#puts s.count
x=map2hash(s)
puts x.inspect
