require "open3"
require "csv"
require 'colorize'
require "active_support/all"
=begin
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
  #conts[]にpdfデータを入れる
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

    #CSVファイルを作成
    def select_csv(csv)
      unless File.exist?(csv)
        return csv
      else
        return @tmp_csv
      end
    end

    #CSVファイルに書き込み
    def write_csv(csv, conts)
      CSV.open(csv,'w') do |csv|
        conts.each do |cont|
          csv << cont
        end
      end
    end
  end
=end
#list_csv = NewCSV.new
csv = "readme_cl.csv"
org = "README_test.org"
cl_array = []
tmp_array = []
csv_data = CSV.read(csv,headers: false)
p csv_data.class
  # readme_cl.csv -> array[]
csv_data.each do |line|
  cl_array << line
end
  # README.org - > tmp_array[]
n = 0
File.open(org,"r") do |file|
  file.each do |line|
    if path = line.match(/\[\[(.+).pdf(.*)\]\]/)
      tmp_array << [path[1]+'.pdf',"false"]
    end
  end
end

# diff cl_array[] tmp_array[] -> reviced_array[]
#revised_array = []
#diff = []
#diff = (cl_array & tmp_array).present?
#if diff == false
#end
p cl_array[0]
p tmp_array[0]



out, err, status= Open3.capture3("diff #{tmp_array[0]} #{cl_array[0]}")
if out == ''
  puts "no revision on csv list".green
  exit
end


revised = false
out.split("\n").each do |line|
  revised = true if line.chomp =='---'
  if revised
    p line
    revised_array << line[2..-1].split(',')
    p revised_array
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
