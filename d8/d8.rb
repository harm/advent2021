require 'pp'

def part1
	input = File.read("input.txt")
	signals_row = []
	digits_row = []
	input.strip.split("\n").each do |str_line|
		parts = str_line.split("|")
		signals_row << parts[0].split(" ")
		digits_row << parts[1].split(" ")
	end

	total = 0
	digits_row.each do |digit_row|
		total += digit_row.select{|d| is_part_of_solution?(d) }.count
	end

	pp total
end

def is_part_of_solution?(signal)
	l = signal.length
	[2,3,4,7].any?{|k| k == l}
end

def overlays_with?(target, test)
	test.chars.all? {|c| target.include?(c)}
end

def part2
	input = File.read("input.txt")
	total = 0
	input.chomp.split("\n") do |line|
		input, output = line.split(' | ')
	    values = input.split(' ').map {|v| v.chars.sort.join}
	    
	    # solves for the known lengths
	    table = {
	      1 => values.find {|v| v.length == 2},
	      7 => values.find {|v| v.length == 3},
	      4 => values.find {|v| v.length == 4},
	      8 => values.find {|v| v.length == 7},
	    }

	    # handle all 6 long elements
	    values.select{|v| v.length == 6}.each do |v|
	    	if overlays_with?(v, table[4]) 
	    		table[9] = v
	    	elsif overlays_with?(v, table[1])
	    		table[0] = v
	    	else
	    		table[6] = v
	    	end
	    end

	    # handle all 5 long elements
	    values.select{|v| v.length == 5}.each do |v|
	    	if overlays_with?(v, table[1]) 
	    		table[3] = v
	    	elsif overlays_with?(v, (table[4].chars - table[1].chars).join)
	    		table[5] = v
	    	else
	    		table[2] = v
	    	end
	    end

	    table = table.map {|k, v| [v, k]}.to_h

	    numberic_value = output.split(' ').map {|k| table[k.chars.sort.join]}.join().to_i

	    total += numberic_value
	end
	pp total
end
	
# part 1
part1()
part2()