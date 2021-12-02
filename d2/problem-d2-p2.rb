require 'pp'

position_horizontal = 0
position_depth = 0
position_aim = 0

array_data = file_data = File.readlines("problem2-input.txt").map{|i| [ i.split[0], i.split[1].to_i]}
array_data.each do |row|
	direction = row[0]
	value = row[1]
	if direction == "forward"
		position_horizontal = position_horizontal + value
		position_depth = position_depth + (position_aim * value)
	elsif direction == "up"
		position_aim = position_aim - value
	elsif direction == "down"
		position_aim = position_aim + value
	else
		pp ".....WARNING...."
		break
	end
	pp "D: #{direction}, V: #{value} H: #{position_horizontal}, D: #{position_depth}, A: #{position_aim}"
end

pp position_horizontal * position_depth