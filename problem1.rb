increases = 0
previous_mesurement = nil
file_data = File.foreach("problem1-input.txt") do |line|
	(increases = increases + 1) if !previous_mesurement.nil? and previous_mesurement < line.to_i
	previous_mesurement = line.to_i
end

puts increases
