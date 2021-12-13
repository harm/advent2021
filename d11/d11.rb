class Squid
  attr_accessor :internal_counter
  attr_accessor :neighbours
  attr_accessor :x, :y

  def initialize(x, y, counter)
    @neighbours = []
    @internal_counter = counter
    @x, @y = x, y
  end

  def increase_energy
    @internal_counter += 1
  end

  def reset_energy
    @internal_counter = 0
  end

  def to_s
    "[ic: #{@internal_counter}, x: #{@x}, y: #{y}]"
  end
end

class Grid
  attr_accessor :squids
  attr_accessor :flash_counter
  attr_accessor :step_counter


  def print_grid
    str = "STEP: #{@step_counter}\n"
    @squids.each do |row|
      row.each do |column|
        str = "#{str}#{column.internal_counter}"
      end
      str += "\n"
    end
    str
  end

  def initialize(input)
    @step_counter = 0
    @flash_counter = 0
    @squids = []
    input.readlines.each_with_index do |row, y|
      @squids << row.chomp.split("").each_with_index.map {|column, x| Squid.new(x, y, column.to_i)}
    end

    @squids.flatten.each do |squid|
      # find neighbours
      neighbours = []
      [-1, 0, 1].each do |y|
        [-1, 0, 1].each do |x|
          next if y == 0 && x == 0
          next if squid.y + y < 0 || squid.y + y >= 10
          next if squid.x + x < 0 || squid.x + x >= 10
          neighbours << get_squid_at(squid.x + x, squid.y + y) unless get_squid_at(squid.x + x,squid.y + y) == squid
        end
      end
      squid.neighbours = neighbours
    end
  end

  def get_squid_at(x,y)
    return nil if x < 0 || y < 0 || (x > @squids.first.size - 1) || (y > @squids.size - 1)
    @squids[y][x]
  end

  def step
    @squids.flatten.each{|squid| squid.increase_energy }
    flashed = []
    new_flashes = true
    while new_flashes do
      new_flashes = false
      @squids.flatten.each do |squid|
        if squid.internal_counter > 9 && !flashed.include?(squid)
          new_flashes = true
          flashed << squid
          squid.neighbours.each(&:increase_energy)
        end
      end
    end
    @step_counter += 1
    if flashed.size == @squids.flatten.size
      puts "Solution problem2: #{step_counter}"
      return
    end
    @squids.flatten.select{|s| s.internal_counter > 9}.each(&:reset_energy)
    flashed.size
  end
end

input = File.open 'test-input.txt'
grid = Grid.new(input)

total = 0
puts grid.print_grid
300.times.map do |i|
  total += grid.step
  puts grid.print_grid
end

puts total

