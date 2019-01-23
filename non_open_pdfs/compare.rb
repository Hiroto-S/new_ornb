require "open3"
require "csv"

old_csv_data = []
new_csv_data = []
old_alias = []
new_alias = []
old_ref = []
new_ref = []
i = 0
j = 0
n = 0
csv_name = "readme_cl.csv"
new_csv_name = "new_readme_cl.csv"
latest_csv_name = "latest_readme_cl.csv"
old = CSV.read("#{csv_name}",headers: false)
new = CSV.read("#{new_csv_name}",headers: false)

old.each do |csv|
  old_csv_data[i] = csv
  /\,/ =~ old_csv_data[i].to_s

  old_ref[i] = $`
  old_alias[i] = $'
  old_ref[i] = old_ref[i].to_s.match(/\[\[(.+)pdf/)
  old_alias[i] = old_alias[i].to_s.match(/\w+/)
  i = i+1
end

new.each do |csv|
  new_csv_data[j] = csv.to_s
  /\,/ =~ new_csv_data[j]
  new_alias[j] = $'
  new_ref[j] = $`
  new_ref[j] = new_ref[j].to_s.match(/\[\[(.+)pdf/)
  new_alias[j] = new_alias[j].to_s.match(/\w+/)
  j = j+1
end
#比較
for n in 0..j-1 do
  if old_alias[n] != new_alias[n]
    if new_alias[n].to_s.match(/false/)
      new_alias[n] = old_alias[n]
    end
    n = n + 1
  else
    n = n + 1
  end
  CSV.open("latest_readme_cl.csv","a") do |csv|
    csv << [new_ref[n-1],new_alias[n-1]]
  end
end

#csv(old,new(初期化))の更新
CSV.open("#{csv_name}","w") do |csv|
end
CSV.open("#{new_csv_name}","w") do |csv|
end

n = 0
for n in 0..j-1 do
  CSV.open("#{csv_name}","a") do |data|
    data << [new_ref[n],new_alias[n]]
  end
end
