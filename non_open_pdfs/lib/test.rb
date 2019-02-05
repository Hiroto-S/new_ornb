require 'find'
require 'csv'

csv_data = 'README_cl.csv'

#file =[]
#file << ['scrape.rb']
# file.class
p dir = Dir.glob("**/*")
CSV.foreach("test.csv") do |file|
  if link = file[0].match(/(\w*)\.pdf/)
    if dir.include?(link[0])
      p 'true'
    else
        p 'false'
    end
  end
end
exit
if file == true
  p 'true'
else
  p 'false'
end
