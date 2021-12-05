require 'pp'
require 'colorize'

Point = Struct.new(:x, :y)
 
class Line
  attr_reader :a, :b
 
  def initialize(point1, point2)
    @a = point1
    @b = point2
  end

  def is_horizontal_or_vertical?
    @a.x == @b.x || @a.y == @b.y    
  end

  def points_on_line
    points = []
    if !is_horizontal_or_vertical?
      rc = (@b.y - @a.y) / (@b.x - @a.x)
      b = @a.y - (rc * @a.x)
      xdif = ([@a.x, @b.x].max - [@a.x, @b.x].min)
      startx = [@a.x, @b.x].min
      (xdif + 1).times do |x|
        xc = startx + x
        # now find yc
        yc = rc * xc + b
        points << Point.new(xc, yc)
      end
  else
      xdif = ([@a.x, @b.x].max - [@a.x, @b.x].min)
      ydif = ([@a.y, @b.y].max - [@a.y, @b.y].min)
      if (xdif > 0)
        startx = [@a.x, @b.x].min
        (xdif + 1).times{|i| points << Point.new((startx + i), @a.y) }
      elsif (ydif > 0)
        starty = [@a.y, @b.y].min
        (ydif + 1).times{|i| points << Point.new(@a.x, (starty + i)) }
      else
        throw Exception "Something is wrong"
      end
    end
    points
  end

  def to_s
    "line: p1(#{@a}),p2(#{@b})"
  end
end

class Matrix
  
  def initialize
    @array = Array.new(1000) { Array.new(1000) { 0 } }
  end

  def print_matrix
    str = ""
    @array.transpose.each do |row|
      row.each do |elem|
        if elem == 0
          str += "."
        else
          str += elem.to_s
        end
      end
      str += "\n"
    end
    str
  end

  def add_line(line)
    line.points_on_line.each do |p|
     value = @array[p.x][p.y]
      @array[p.x][p.y] = value + 1
    end
  end

  def points_that_overlap
    points = @array.flatten.select{|elem| elem > 1}
  end
end


matrix = Matrix.new
file_data = File.readlines("input.txt").each do |line|
  line.strip!
  p1, p2 = line.split(" -> ")
  x,y = p1.split(",")
  point1 = Point.new(x.to_i,y.to_i)
  x,y = p2.split(",")
  point2 = Point.new(x.to_i,y.to_i)
  line = Line.new(point1, point2)
  matrix.add_line(line)
end

puts "Points that overlap: #{matrix.points_that_overlap.size}".green

