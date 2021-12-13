Point = Struct.new(:x, :y)

class Grid
  attr_accessor :coordinates
  attr_accessor :folds
  attr_accessor :width, :height

  def print_grid
    rows = []

    0.upto(@height - 1) do |row|
      row = []
      0.upto(@width - 1) do |col|
        row[col] = " "
      end
      rows << row
    end

    @coordinates.each do |c|
      rows[c.y][c.x] = "█"
    end

    rows.each do |row|
      puts row.join()
    end
  end

  def initialize(input)
    @coordinates = []
    @folds = %w[X-655 Y-447 X-327 Y-223 X-163 Y-111 X-81 Y-55 X-40 Y-27 Y-13 Y-6]
    input.split("\n").each do |row|
      x, y = row.chomp.split(",")
      @coordinates << Point.new(x.to_i,y.to_i)
    end
    @width = @coordinates.map{|p| p.x }.max
    @height = @coordinates.map{|p| p.y }.max
  end

  def fold_grid
    @folds.each do |row|
      axis, value = row.split("-")
      value = value.to_i
      if axis == "X"
        fold_grid_x(value)
      elsif axis == "Y"
        fold_grid_y(value)
      end
    end
  end
end

def fold_grid_y(fold_line)
  mirrored_points = []
  @coordinates.select{|c| c.y > fold_line}.each do |coordinate|
    distance = coordinate.y - fold_line
    mirrored_points << Point.new(coordinate.x, fold_line - distance)
  end
  @coordinates += mirrored_points
  @coordinates = @coordinates.select { |c| c.y < fold_line }.uniq
  @height = (@height / 2.0).floor
end

def fold_grid_x(fold_line)
  mirrored_points = []
  @coordinates.select{|c| c.x > fold_line}.each do |coordinate|
    distance = coordinate.x - fold_line
    mirrored_points << Point.new(fold_line - distance, coordinate.y)
  end
  @coordinates += mirrored_points
  @coordinates = @coordinates.select { |c| c.x < fold_line }.uniq
  @width = (@width / 2.0).floor
end

input = File.read("input.txt")
g = Grid.new(input)
g.fold_grid
puts g.coordinates.size
g.print_grid
