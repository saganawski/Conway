require_relative 'game_of_life.rb'


board = Board.new
game = Game.new(board)
# To racnomly populate inital board un-comment line 8
# game.randomly_populate


loop do 

	game.board.display(game)

	game.tick!
	
	live_count = game.board.live_count(game)
	break if live_count == 0

	sleep 1
end
