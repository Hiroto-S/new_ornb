# encoding: UTF-8
require "open3"
require "csv"

org_name = "README_test.org"
csv_name = "readme_cl.csv"
new_org_name = "README_after_change.org"
#orgからpdfのリンクを抽出
m = []
File.open("#{org_name}","r") do |file|
 file.each do |line|
  if m = line.match(/\[\[(.+)pdf/)
    CSV.open("#{csv_name}","a") do |csv|
      csv << [m,'NoChange']
    end
  end
 end
end

#csvデータの読み込みと新しいファイルの作成
csv_data = CSV.read("#{csv_name}",headers: false)
new_org = File.open("#{new_org_name}","w")

#csvデータを配列に代入
str = []
b = []
i = 0
csv_data.each do |csv|
  str[i] = csv.to_s
  /\,/ =~ str[i]
  b[i] = $'
  i = i+1
end

#csvデータの変更点を新しいorgに反映
n = 0
cnt = 0
File.open("#{org_name}","r") do |file|
  file.each do |line|
    if line.match(/\[\[(.+)pdf/)
      if str[n].match(/[\#{line}]/)
        unless str[n].match(/NoChange/)
          source = line.gsub(/\-|\]|\n|" "/, "")
          line = b[n]
          new_org.print "-#{source}][#{line}]\n"
          cnt = 1
        end
        n = n+1
      end
    end
    if cnt == 0
      new_org.print "#{line}\n"
    else
      cnt = 0
    end
  end
end
