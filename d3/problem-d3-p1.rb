require 'pp'

def problem1(input)
	array_data = input.transpose
	gamma = array_data.map{|row| row.max_by { |i| row.count(i) }}
	epsilon = array_data.map{|row| row.min_by { |i| row.count(i) }}
	gamma_bin = gamma.join().to_i(2)
	epsilon_bin = epsilon.join().to_i(2)
	result = gamma_bin * epsilon_bin
	pp "Gamma: #{gamma_bin}, Epsilon: #{epsilon_bin}, Solution: #{result}"
end

def get_reading(input, most_common=true)
	position = 0
	while input.size > 1 do
		row = input.transpose[position]
		most_common ? (mask = (row.count(1) >= row.count(0)) ? 1 : 0) : (mask = (row.count(1) >= row.count(0)) ? 0 : 1)	
		input = input.reject{|elem| elem[position] != mask}
		position = position + 1
	end
	return input[0]
end

def problem2(input)
	oxigen = get_reading(input).join().to_i(2)
	co2 = get_reading(input, false).join.to_i(2)
	pp "Oxigen: #{oxigen}, co2: #{co2}, Solution: #{oxigen * co2}"
end

input = File.readlines("input.txt").map{|row| row.delete("\n")}.map{|row| row.chars.map{|i| i.to_i } }

problem1(input)
problem2(input)

