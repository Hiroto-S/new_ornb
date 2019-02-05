# -*- coding: utf-8 -*-
require "open3"
require "csv"
require 'colorize'
#require './tree.rb'


class GetListFromOrg
  attr_reader :conts
  def initialize(org)
    mk_conts(org)
  end

  def mk_conts(org)
    @conts = []
    File.open(org,"r") do |file|
      file.each do |line|
        if path = line.match(/\[\[(.+).pdf(.*)\]\]/)
          @conts << [path[1]+'.pdf','false']
        end
      end
    end
    @conts
  end
end

class GetList < GetListFromOrg
  attr_reader :org, :csv, :status, :conts
  def initialize(org)
    @org = org
    @csv = File.basename(@org,'.org')+'_cl.csv'
    @status = true
    unless File.exist?(@csv)
      write_csv(@csv, mk_conts(@org))
    else
      @conts = CSV.read(@csv,headers: false)
    end
  end

  def write_csv(csv, conts)
    CSV.open(csv,'w') do |csv|
      conts.each{|cont| csv << cont}
    end
  end
end

file = ARGV[0] || 'README.org'
list_csv = GetList.new(file)
list_array = list_csv.conts
tmp_array = GetListFromOrg.new(file).conts
diff_array = list_array - tmp_array

list_name = []
tmp_name = []
list_array.each do |cont|
  list_name << cont[0]
end
tmp_array.each do |cont|
  tmp_name << cont[0]
end

m = tmp_name - list_name

p csv_file = CSV.readlines("test.csv",headers: false)
CSV.open(csv_file,'a') do |csv|
  m.each do |cont|
    csv << [cont,'false']
    diff_array << [cont,'false']
  end
end

revised_name = []
CSV.foreach(csv_file) do |file|
  p file[0]

  revised_name << file[0]
end

dir = Dir.glob("**/*")
CSV.foreach(csv_file) do |file|
  if link = file[0].match(/(\w*)\.pdf/m)
    unless dir.include?(link[0])
      puts "#{link[0]} does not exist".red
    end
  end
end

#p '----------'
#p revised_name
#if dir.include?(revised_name)
#  p 'true'
#end

def rev_line(line, diff_array)
  diff_array.each do |cont|
    base_name = File.basename(cont[0])
    tmp = base_name+":"+cont[1]
  end
  return line
end

conts = ""
File.readlines(list_csv.org).each do |line|
  revised = rev_line(line, diff_array)
  conts << revised
end

File.open('tmp.org','w'){|f| f.print conts}
