require 'pp'

position_horizontal = 0
position_depth = 0


increases = 0
previous_mesurement = nil
array_data = file_data = File.readlines("problem2-input.txt").map{|i| [ i.split[0], i.split[1].to_i]}

array_data.each do |row|
	direction = row[0]
	value = row[1]

	pp "Direction: #{direction}, value: #{value}"

	if direction == "forward"
		position_horizontal = position_horizontal + value
	elsif direction == "up"
		position_depth = position_depth - value
	elsif direction == "down"
		position_depth = position_depth + value
	else
		pp ".....WARNING...."
		pp position
		break
	end

	pp "Horizontal: #{position_horizontal}, depth: #{position_depth}"
end

pp position_horizontal * position_depth

# tupels = array_data.each_with_index.map{|item, index| array = [ array_data[index], array_data[index + 1], array_data[index + 2] ] }
# tupels.reject! {|row| row.any? { |elem| elem.nil?  } }
# averages_array = tupels.map{|row| row.inject(0.0) { |sum, el| sum + el.to_i } / row.size }

# increases = 0
# previous_mesurement = nil
# averages_array.each do |line|
# 	(increases = increases + 1) if !previous_mesurement.nil? and previous_mesurement < line
# 	previous_mesurement = line
# end

# pp increases


#  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 
