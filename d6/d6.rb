FISH_ARRAY = [1,3,3,4,5,1,1,1,1,1,1,2,1,4,1,1,1,5,2,2,4,3,1,1,2,5,4,2,2,3,1,2,3,2,1,1,4,4,2,4,4,1,2,4,3,3,3,1,1,3,4,5,2,5,1,2,5,1,1,1,3,2,3,3,1,4,1,1,4,1,4,1,1,1,1,5,4,2,1,2,2,5,5,1,1,1,1,2,1,1,1,1,3,2,3,1,4,3,1,1,3,1,1,1,1,3,3,4,5,1,1,5,4,4,4,4,2,5,1,1,2,5,1,3,4,4,1,4,1,5,5,2,4,5,1,1,3,1,3,1,4,1,3,1,2,2,1,5,1,5,1,3,1,3,1,4,1,4,5,1,4,5,1,1,5,2,2,4,5,1,3,2,4,2,1,1,1,2,1,2,1,3,4,4,2,2,4,2,1,4,1,3,1,3,5,3,1,1,2,2,1,5,2,1,1,1,1,1,5,4,3,5,3,3,1,5,5,4,4,2,1,1,1,2,5,3,3,2,1,1,1,5,5,3,1,4,4,2,4,2,1,1,1,5,1,2,4,1,3,4,4,2,1,4,2,1,3,4,3,3,2,3,1,5,3,1,1,5,1,2,2,4,4,1,2,3,1,2,1,1,2,1,1,1,2,3,5,5,1,2,3,1,3,5,4,2,1,3,3,4]

class Fish
	attr_accessor :internal_counter
	attr_accessor :parent
	attr_accessor :children

	def initialize(school, counter)
		@internal_counter = counter
		@parent = nil
		@children = []
		@school = school
	end

	def age
		@internal_counter = @internal_counter - 1
		if @internal_counter < 0
			spawn()
			@internal_counter = 6
		end
	end

	def spawn()
		fish = Fish.new(@school, 9)
		fish.parent = self
		children << fish
		@school.fish << fish
		fish
	end
end

class School

	attr_accessor :fish

	def initialize
		@fish = []
		FISH_ARRAY.each do |i|
			@fish << Fish.new(self, i)
		end
	end

	def age
		@fish.each{|f| f.age }
	end

	def print_school
		@fish.each.map{|f| f.internal_counter }.join(",")
	end
end



school = School.new
puts "Total fish: #{school.fish.size}"

80.times do 
	school.age
	#puts school.print_school
end

puts "Total fish: #{school.fish.size}"

