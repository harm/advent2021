mapping = {}

File.readlines("input.txt").each do |line|
  key, value = line.chomp.split("->")
  mapping[key.strip] = value.strip
end

template = "KHSSCSKKCPFKPPBBOKVF"
array = template.split("")

40.times do
  new_row = []
  pairs = 0.upto(array.length-2).each_with_index.map{|i| "#{array[i]}#{array[i+1]}"}
  pairs.each_with_index do |pair, i|
    c = pair.split("")
    new_row << "#{c[0]}#{mapping[pair]}"
    if i == pairs.length - 1
      new_row << c[1]
    end
  end
  array = new_row.join.split("")
  puts array.size
end

values = array.tally.values.minmax
puts "Solution 1: #{values[1]-values[0]}"
