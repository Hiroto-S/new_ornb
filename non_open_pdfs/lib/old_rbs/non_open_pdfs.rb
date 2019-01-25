# encoding: UTF-8
require "open3"
require "csv"

org_name = "README_test.org"
latest_csv_name = "latest_readme_cl.csv"
new_org_name = "README_after_change.org"
csv_data = CSV.read("#{latest_csv_name}",headers: false)
new_org = File.open("#{new_org_name}","w")

str = []
b = []
i = 0
csv_data.each do |csv|
  str[i] = csv.to_s
  /\,/ =~ str[i]
  b[i] = $'
  i = i+1
end


n = 0
cnt = 0
File.open("#{org_name}","r") do |file|
  file.each do |line|
    if line.match(/\[\[(.+)pdf/)
      if str[n].match(/[\#{line}]/)
        unless str[n].match(/false/)
          source = line.gsub(/\-|\]|\n|" "/, "")
          line = b[n]
          #          new_org.print "-#{source}][#{line}]\n"
                    new_org.print "-#{source}][#{line}]\n"
          cnt = 1
        end
        n = n+1
      end
    end
    if cnt == 0
      new_org.print "#{line}"
    else
      cnt = 0
    end
  end
end
CSV.open("#{latest_csv_name}","w") do |csv|
end
