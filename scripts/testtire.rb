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

s=Tire.search do
  query do
    string "nodename:vb*"
  end
  filter :exists, :field => "updated_resources"
  size 100
end

puts s.results.count
s.results.each do |rslt|
  puts rslt[:updated_resources]
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
