# -*- coding: utf-8 -*-
require "open3"
require "csv"
require 'colorize'

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

p revised_array = list_array - tmp_array

def rev_line(line, revised_array)
  revised_array.each do |cont|
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
