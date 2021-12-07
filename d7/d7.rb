def find_solution(expensive_fuel)
	input = File.read("input.txt").split(",").map{|v| v.to_i }
	input = input.sort
	min_position, max_position = input.minmax

	fuel_cost = 0
	fuel_costs = []

	min_position.upto(max_position + 1) do |position|
		input.each do |other_position|
			min, max = [position, other_position].minmax
			if expensive_fuel
				n = (max - min).abs
				fuel_cost += n * (n + 1) / 2
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