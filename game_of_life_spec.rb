require 'rspec'
require_relative 'game_of_life.rb'

describe 'game_of_life' do
	let(:board) {Board.new}
	let(:cell)  {Cell.new(1,1)}
	let(:game) {Game.new(board)}

	context 'cell' do 
		subject {Cell.new}
		it 'should create a new cell object' do
			expect(subject).to be_a_kind_of(Cell)
		end

		it'should respond to methods' do 
			expect(subject).to respond_to(:alive)
			expect(subject).to respond_to(:x)
			expect(subject).to respond_to(:y)
			expect(subject).to respond_to(:alive?)
			expect(subject).to respond_to(:die!)

		end

		it 'should initialize properly' do
			expect(subject.alive).to be false
			expect(subject.x).to be 0
			expect(subject.y).to be 0
		end
	end 

	context 'board' do
		subject {Board.new}

		it 'should create a new board object' do
			expect(subject).to be_a_kind_of(Board)
		end

		it 'should respond to methods'do
			expect(subject).to respond_to(:rows)
			expect(subject).to respond_to(:cols) 
			expect(subject).to respond_to(:cell_grid)
			expect(subject).to respond_to(:live_neighbors) 
			expect(subject).to respond_to(:cells) 

		end

		it 'should create cell grid' do 
			expect(subject.cell_grid).to be_kind_of Array
		end

		it 'should add all cells to cells array' do 
			expect(subject.cells.count).to be 2500
		end

		it 'should detect the neighbor to the north' do
			expect(subject.cell_grid[cell.y-1][cell.x].alive = true).to be true
			expect(subject.live_neighbors(cell).count).to  be 1
		end

		it 'should detect the neighbor to the south' do
			expect(subject.cell_grid[cell.y+1][cell.x].alive = true).to be true
			expect(subject.live_neighbors(cell).count).to  be 1
		end

		it 'should detect the neighbor to the east' do
			expect(subject.cell_grid[cell.y][cell.x + 1].alive = true).to be true
			expect(subject.live_neighbors(cell).count).to  be 1
		end

		it 'should detect the neighbor to the west' do 
			expect(subject.cell_grid[cell.y][cell.x - 1].alive = true).to be true
			expect(subject.live_neighbors(cell).count).to  be 1
		end

		it 'should detect the neighbor to the north east' do
			expect(subject.cell_grid[cell.y - 1][cell.x + 1].alive = true).to be true
			expect(subject.live_neighbors(cell).count).to  be 1
		end

		it 'should detect the neighbor to the north west' do 
			expect(subject.cell_grid[cell.y - 1][cell.x - 1].alive = true).to be true
			expect(subject.live_neighbors(cell).count).to  be 1
		end

		it 'should detect the neighbor to the south west' do 
			expect(subject.cell_grid[cell.y + 1][cell.x - 1].alive = true).to be true
			expect(subject.live_neighbors(cell).count).to  be 1
		end

		it 'should detect the neighbor to the south east' do 
			expect(subject.cell_grid[cell.y + 1][cell.x + 1].alive = true).to be true
			expect(subject.live_neighbors(cell).count).to  be 1
		end
	end

	context 'game' do
		subject {Game.new}
		it 'should create a new game' do
			expect(subject).to be_a_kind_of(Game)
		end

		it'should respond to methods' do 
			expect(subject).to respond_to(:board)
		end

		it 'should initialize properyly' do
			game = Game.new(board)
			expect(board.cell_grid[0][0]).to be_alive
			expect(board.cell_grid[0][1]).to be_alive
			expect(board.cell_grid[1][0]).to be_alive
			expect(board.cell_grid[3][1]).to be_alive
			expect(board.cell_grid[1][2]).to be_alive
			expect(board.cell_grid[2][2]).to be_alive
		end
	end

	context 'rules' do
		context'Rule #1: Any live cell with fewer than two live neighbours dies, as if caused by underpopulation.' do
			it 'Kills live cell with no neighbours' do
				game.board.cells.each {|cell| cell.die!}
				alive_count = game.board.cells.select {|cell| cell.alive}
				expect(alive_count.count).to be 0
				game.board.cell_grid[1][1].revive!

				alive_count = game.board.cells.select {|cell| cell.alive}
				expect(alive_count.count).to be 1
				game.tick!

				alive_count = game.board.cells.select {|cell| cell.alive}
				expect(alive_count.count).to be 0

			end
		end

		context 'Rule #2: Any live cell with two or three live neighbours lives on to the next generation.' do
			it 'should keep alive cell with 2  live neighbours to the next generation' do 
				game.board.cells.each {|cell| cell.die!}
				alive_count = game.board.cells.select {|cell| cell.alive}
				expect(alive_count.count).to be 0
				game.board.cell_grid[1][1].revive!
				game.board.cell_grid[0][1].revive!
				game.board.cell_grid[2][1].revive!

				game.tick!

				expect(game.board.cell_grid[1][1].alive?).to be true

			end

			it 'should keep alive cell with 2  live neighbours to the next generation' do 
				game.board.cells.each {|cell| cell.die!}
				alive_count = game.board.cells.select {|cell| cell.alive}
				expect(alive_count.count).to be 0
				game.board.cell_grid[1][1].revive!
				game.board.cell_grid[0][1].revive!
				game.board.cell_grid[2][1].revive!
				game.board.cell_grid[1][2].revive!

				game.tick!

				expect(game.board.cell_grid[1][1].alive?).to be true

			end
		end

		context 'Rule #3: Any live cell with more than three live neighbours dies, as if by overpopulation' do
			it "should kill live cell with more then 3 live neighbours" do 
				game.board.cells.each {|cell| cell.die!}
				alive_count = game.board.cells.select {|cell| cell.alive}
				expect(alive_count.count).to be 0
				game.board.cell_grid[1][1].revive!
				game.board.cell_grid[0][1].revive!
				game.board.cell_grid[2][1].revive!
				game.board.cell_grid[1][2].revive!
				game.board.cell_grid[1][0].revive!

				game.tick!

				expect(game.board.cell_grid[1][1].alive?).to be false
			end
		end

		context 'Rule #4: Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction' do
			it 'should revive a dead cell with three live neighbours' do
				game.board.cells.each {|cell| cell.die!}
				alive_count = game.board.cells.select {|cell| cell.alive}
				expect(alive_count.count).to be 0
				game.board.cell_grid[0][1].revive!
				game.board.cell_grid[2][1].revive!
				game.board.cell_grid[1][2].revive!

				game.tick!

				expect(game.board.cell_grid[1][1].alive?).to be true
			end
		end

	end
end


















