require 'pp'

increases = 0
previous_mesurement = nil
array_data = file_data = File.read("problem1-input.txt").split

tupels = array_data.each_with_index.map{|item, index| array = [ array_data[index], array_data[index + 1], array_data[index + 2] ] }
tupels.reject! {|row| row.any? { |elem| elem.nil?  } }
averages_array = tupels.map{|row| row.inject(0.0) { |sum, el| sum + el.to_i } / row.size }

increases = 0
previous_mesurement = nil
averages_array.each do |line|
	(increases = increases + 1) if !previous_mesurement.nil? and previous_mesurement < line
	previous_mesurement = line
end

pp increases


