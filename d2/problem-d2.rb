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