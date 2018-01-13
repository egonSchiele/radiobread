require_relative "lib/radiobread"

File.open("lib/radiobread/bands.txt").each do |band|
  puts band
  puts Radiobread.get_puns(band)
  puts "\n\n"
end
