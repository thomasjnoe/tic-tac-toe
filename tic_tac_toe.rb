#!/usr/bin/env ruby

class TicTacToe
	attr_reader :player1, :player2, :conditions
	attr_accessor :grid, :turns, :playing

	def initialize
		@player1 = Player.new("X")
		@player2 = Player.new("O")
		@grid = (1..9).to_a
		@turns = 0
		@playing = true
		populate_win_conditions
	end

	def populate_win_conditions
		row1 = grid.each_index.select { |i| (i+1) <= 3 }
		row2 = grid.each_index.select { |i| (i+1) > 3 && (i+1) < 7 }
		row3 = grid.each_index.select { |i| (i+1) >= 7 }
		col1 = grid.each_index.select { |i| (i+1) == 1 || (i+1) == 4 || (i+1) == 7 }
		col2 = grid.each_index.select { |i| (i+1) == 2 || (i+1) == 5 || (i+1) == 8 }
		col3 = grid.each_index.select { |i| (i+1) == 3 || (i+1) == 6 || (i+1) == 9 }
		diagonal1 = grid.each_index.select { |i| (i+1) == 1 || (i+1) == 5 || (i+1) == 9 }
		diagonal2 = grid.each_index.select { |i| (i+1) == 3 || (i+1) == 5 || (i+1) == 7 }
		@conditions = [row1,row2,row3,col1,col2,col3,diagonal1,diagonal2]
	end

	def play_game
		while playing
			reset_board
			reset_turns
			puts "\nLet's play Tic-Tac-Toe!\n"
			game_loop
			puts "\nPlayer #{player_turn} wins!" if winner?
			puts "\nThe game ends in a tie!" if tie? && !winner?
			display_board
			play_again?
		end
		puts "Thanks for playing!"
	end

	private

	def display_board
		grid.each_with_index do |square, index|
			if (index+1) % 3 == 0
				print " #{square} \n"
				print "-----------\n" if square != 9
			else
				print " #{square} |"
			end
		end
	end

	def player_turn
		# Alternate players each turn
		turns % 2 != 0 ? player1.symbol : player2.symbol
	end

	def game_loop
		until winner? || tie?
			self.turns += 1
			puts "\nPlayer #{player_turn}, pick a square:"
			display_board
			pick_square
		end
	end

	def pick_square
		begin
			# Check if input is a number
			square = gets.chomp.match(/\d/)[0]
		rescue
			puts "Invalid input! Please pick a square:"
			display_board
			retry
		else
			# Check if square has already been selected
			if square_already_selected?(square.to_i - 1)
				puts "\nSquare has already been picked! Pick another square:"
				display_board
				pick_square
			else
				# Set chosen square to "X" or "O" depending on the player
				grid[square.to_i - 1] = player_turn
			end
		end
	end

	def square_already_selected?(square)
		grid[square] == "X" || grid[square] == "O"
	end

	def reset_board
		self.grid = (1..9).to_a
	end

	def reset_turns
		self.turns = 0
	end

	def winner?
		# Check if any of the win conditions are met
		conditions.any? { |condition| condition.all? { |i| grid[i] == "X" } || condition.all? { |i| grid[i] == "O" } }
	end

	def tie?
		# Check if the board is full without any winning conditions met
		conditions.all? { |condition| condition.all? { |i| grid[i] == "X" || grid[i] == "O" } }
	end

	def play_again?
		puts "\nPlay again? (Y/N):"
		prompt = gets.chomp
		self.playing = 
			if prompt.to_s.downcase == "y"
				true
			else
				false
			end
	end

	class Player
		attr_accessor :symbol

		def initialize(symbol)
			@symbol = symbol
		end

	end

end

game = TicTacToe.new
game.play_game
