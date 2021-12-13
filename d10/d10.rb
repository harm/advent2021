INPUT = <<-DATA
[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]
DATA

MAPPING = { '[' => ']', '(' => ')', '{' => '}', '<' => '>' }
INV_MAPPING = MAPPING.invert

def analyze(input)
	illegal_chars = []
 	opening_chars = []

 	closing = false
 	input.chars.each_with_index do |c1, index|
 	 	if MAPPING.keys.include?(c1) != closing
 	 		opening_chars << c1
 	 	else
 	 		closing = true
 	 		#must be closing char 	
 	 		c2 = opening_chars.pop

 	 		puts "c2: #{c2}, c1: #{c1}"
 	 		if c1 == MAPPING[c2]
 	 			puts "matching pair"
 	 		else
 	 			puts "illegal char"
 	 			illegal_chars << c1
 	 			break
 	 		end

 	 		closing = false if opening_chars.size < 1
 	 	end
 	end

 	illegal_chars
end

# puts INV_MAPPING

# illegal_chars = []
# INPUT.split("\n").each do |line|


# end

# puts illegal_chars.inspect

