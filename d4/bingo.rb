require 'pp'
require 'colorize'

NUMBERS = [79,9,13,43,53,51,40,47,56,27,0,14,33,60,61,36,72,48,83,42,10,86,41,75,16,80,15,93,95,45,68,96,84,11,85,63,18,31,35,74,71,91,39,88,55,6,21,12,58,29,69,37,44,98,89,78,17,64,59,76,54,30,65,82,28,50,32,77,66,24,1,70,92,23,8,49,38,73,94,26,22,34,97,25,87,19,57,7,2,3,46,67,90,62,20,5,52,99,81,4]

class BingoCard
	attr_accessor :rows

	def initialize()
		@rows = []
	end

	def check_win
		check_horizonal_win || check_vertical_win
	end

	def check_vertical_win
		@rows.transpose.any?{|row| row.all?{|field| field.score }}
	end

	def check_horizonal_win
		@rows.any?{|row| row.all?{|field| field.score } }
	end

	def card_score
		@rows.flatten.select{|c|!c.score}.inject(0){|sum,c| sum + c.value}
	end

	def to_s
		rows.map{|r| r.map{|f| f.to_s }.join("|") }.join("\n") 
	end

	def call_number(number)
		@rows.flatten.each { |field| field.score = true if (field.value == number) }
	end
end

class BingoField
	attr_accessor :value
	attr_accessor :score

	def initialize(value)
		@value = value
		@score = false
	end

	def to_s
		@score ? 'x' : '.'
	end
end


def read_cards()
	cards = []
	card = BingoCard.new
	file_data = File.read("input.txt").split(/^$/).each do |str_card|
		card = BingoCard.new
		str_card.split(/\n/).select{|x|!x.empty?}.each do |row|
			row = row.strip()
			card.rows << row.split(/\s+/).map{|elem| BingoField.new(elem.to_i) }
		end
		cards << card
	end
	cards
end

def runBingo()
	first_card = nil
	cards = read_cards()
	NUMBERS.each do |number|
		cards.each do |card|
			card.call_number(number)
			if card.check_win
				if cards.select{|c|c.check_win }.size == 1 && first_card == nil
					first_card = card
					puts "Card score: #{card.card_score}"
					puts "Solution part 1: #{card.card_score * number}".green
				end
				if cards.all?{|c| c.check_win }
					puts "Card score: #{card.card_score}"
					puts "Solution part 2: #{card.card_score * number}".green
					return
				end
			end
		end
	end
end

runBingo()



