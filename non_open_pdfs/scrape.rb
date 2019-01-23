require "open3"
require "csv"
require 'colorize'

class NewCSV
  attr_reader :org, :csv, :tmp_csv
  def initialize(*argv)
    @org = ARGV[0] || "README_test.org"
    #new_org = "README_after_change.org"
    @csv = "readme_cl.csv"
    @tmp_csv = "tmp_readme_cl.csv"

    conts = mk_conts(@org)
    target_csv = select_csv(@csv)
    write_csv(target_csv, conts)
  end

  def mk_conts(org)
    conts = []
    File.open(org,"r") do |file|
      file.each do |line|
        if path = line.match(/\[\[(.+).pdf(.*)\]\]/)
          conts << [path[1]+'.pdf',false]
        end
      end
    end
    conts
  end

  def select_csv(csv)
    unless File.exist?(csv)
      return csv
    else
      return @tmp_csv
    end
  end

  def write_csv(csv, conts)
    CSV.open(csv,'w') do |csv|
      conts.each do |cont|
        csv << cont
      end
    end
  end
end

list_csv = NewCSV.new
#p revised_array

out, err, status= Open3.capture3("diff #{list_csv.tmp_csv} #{list_csv.csv}")
if out == ''
  puts "no revision on csv list".green
  exit
end
revised_array = []
revised = false
out.split("\n").each do |line|
  revised = true if line.chomp =='---'
  if revised
    p line
    revised_array << line[2..-1].split(',')
  end
end


def rev_line(line, revised_array)
  revised_array[1..-1].each do |cont|
    base_name = File.basename(cont[0])
    tmp = base_name+":"+cont[1]
    line.gsub!(cont[0],tmp)
  end
  return line
end

conts = ""
File.readlines(list_csv.org).each do |line|
  revised = rev_line(line, revised_array)
  conts << revised
end

File.open('tmp.org','w'){|f| f.print conts}
