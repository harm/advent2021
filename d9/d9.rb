require 'pp'
require 'set'

INPUT = %Q{2199943210
3987894921
9856789892
8767896789
9899965678}

LIMIT = 9

Point = Struct.new(:x, :y, :val, :marked)

class HeightMap

	def initialize
		@input = []
		input = INPUT.strip.split("\n").each_with_index do |line, y|
		#input = File.read("input.txt").split(/\n/).each_with_index do |line, y|
			@input[y] = line.chars.each_with_index.map do |v,x| 
				p = Point.new
				p.x = x.to_i
				p.y = y.to_i
				p.val = v.to_i
				p.marked = false
				p
			end
		end
		@max_x = @input.first.length
		@max_y = @input.length
	end

	def to_s
		str = ""
		@input.each do |row|
			row.each do |col|
				str << (col.marked ? "*" : col.val.to_s)
			end
			str << "\n"
		end
		str
	end

	def get_point(x,y)
		return @input[y][x]
	end

	def get_neighbours(x,y)
		neighbours = []
        neighbours << get_point(x-1,y) if x > 0
        neighbours << get_point(x+1,y) if x < @max_x - 1
        neighbours << get_point(x,y-1) if y > 0
        neighbours << get_point(x,y+1) if y < @max_y - 1
		neighbours
	end

	def find_low_points
		low_points = []
		neighbours = []
		@input.each do |row|
			row.each do |cell|
				#puts cell
				neighbours = get_neighbours(cell.x, cell.y)
				low_points << cell if neighbours.all?{|neighbour| neighbour.val > cell.val}
			end
		end
		low_points
	end

	def find_basin(xset, low_point)
		neighbours = get_neighbours(low_point.x, low_point.y)
		neighbours.each do |n|
			if n.val < LIMIT && xset.add?([n.x, n.y])
				find_basin(xset, n)
			end
		end
		xset
	end
end

hm = HeightMap.new

# # #puts hm.to_s
low_points =  hm.find_low_points

pp "Score problem1: #{low_points.map{|v| v.val + 1}.sum}"
pp low_points

basins = []
low_points.each do |point|
    set = Set.new([point.x, point.y])
    basin = hm.find_basin(set, point)
    puts basin.inspect
    basins << set.size       
end
top_3 = basins.max(3)

puts hm.to_s

puts top_3.inspect
solution = top_3[0] * top_3[1] * top_3[2]
pp "Solution problem2: #{solution}"

