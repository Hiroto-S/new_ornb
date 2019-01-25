require 'open3'

name = ARGV[0]

d = File.open('head_code.txt','r')
s = File.open(name,'r')
data = d.read
source = s.read

File.open(name,'w') do |f|
  f.print("#{data}\n")
  f.print("#{source}\n")
end
