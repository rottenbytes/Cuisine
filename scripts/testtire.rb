require "rubygems"
require "tire"

s=Tire.search 'chef_reports' do
  criterias = {}
  criterias[:string] = {}
  criterias[:string][:nodename] = "*" 
  criterias[:string][:updated_resources] ="*resolv*"
  
  str_args=[]
  criterias[:string].each_pair { |k,v| str_args.push "#{k}:#{v}" }

  str_query=str_args.join(" AND ")

  query { string str_query }
  sort { by :start_time, "desc" }
  size 5
end


x=s.results.map { |rslt| rslt.to_hash }

puts "------------------------------------"
x.each do |y|
  puts y.inspect
  puts ""
end
puts "------------------------------------"

for i in 0..x.count-1 do
  puts i
  x[i][:diffs]=x[i][:diffs].to_hash unless x[i][:diffs].nil?
end

puts "####################################"
puts x.inspect
puts "####################################"

