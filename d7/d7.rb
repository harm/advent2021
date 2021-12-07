def find_solution(expensive_fuel)
	input = File.read("input.txt").split(",").map{|v| v.to_i }
	input = input.sort

	max_position = input.max
	min_position = input.min

	fuel_cost = 0
	fuel_costs = []

	min_position.upto(max_position + 1) do |position|
		#move all to position
		input.each do |other_position|
			max = [position, other_position].max
			min = [position, other_position].min
			if expensive_fuel
				(min+1).upto(max).each_with_index {|position, index| fuel_cost = fuel_cost + (index + 1) }
			else
				fuel_cost = fuel_cost + (max - min)
			end			
		end
		fuel_costs << fuel_cost
		fuel_cost = 0
	end

	return fuel_costs.min
end



puts "Solution problem1: #{find_solution(false)}"
puts "Solution problem2: #{find_solution(true)}"