require "open3"
require "csv"


csv_name = "readme_cl.csv"
new_csv_name = "new_readme_cl.csv"
org_name = "README_test.org"
new_org_name = "README_after_change.org"

old = CSV.read("#{csv_name}",headers: false)
path = []
if old.empty? == true
  File.open("#{org_name}","r") do |file|
   file.each do |line|
    if path = line.match(/\[\[(.+)pdf\][.?|\[(.+)\]]\]/)
      CSV.open("#{csv_name}","a") do |csv|
        csv << [path,"false"]
      end
      CSV.open("#{new_csv_name}","a") do |csv|
        csv << [path,"false"]
      end
    end
   end
 end
else
  File.open("#{org_name}","r") do |file|
   file.each do |line|
    if path = line.match(/\[\[(.+)pdf/)
      CSV.open("#{new_csv_name}","a") do |csv|
        csv << [path,"false"]
      end
    end
   end
  end
end

new = CSV.read("#{new_csv_name}",headers: false)
