class Game
  attr_accessor :board
  def initialize(board = Board.new)
    @board = board
    board.cell_grid[0][0].revive!
    board.cell_grid[0][1].revive!
    board.cell_grid[1][0].revive!
    board.cell_grid[3][1].revive!
    board.cell_grid[1][2].revive!
    board.cell_grid[2][2].revive!
  end

  def tick!
    next_round_live_cells = []
    next_round_dead_cells = []
    board.cells.each do |cell|
      # rule 1
      # any live cell with fewer then two live neighbors dies
      if cell.alive? && board.live_neighbors(cell).count < 2
        next_round_dead_cells << cell
      end

      # rule 2
      # any live cell with two or three live neighbors lives on to the next generation
      if cell.alive? && board.live_neighbors(cell).count == 2 || board.live_neighbors(cell).count == 3
        next_round_live_cells << cell
      end

      #rule 3
      # any live cell with more than 3 live neighbors
      if cell.alive? && board.live_neighbors(cell).count > 3
        next_round_dead_cells << cell
      end

      #rule 4
      # any dead cell with exactly three live neighbors become a live
      if cell.dead? && board.live_neighbors(cell).count == 3
        next_round_live_cells << cell
      end
    end

    next_round_live_cells.each do |cell|
      cell.revive!
    end

    next_round_dead_cells.each do |cell|
      cell.die!
    end
  end
end

class Board
  attr_accessor :rows, :cols, :cell_grid, :cells

  # Scheme of default initialized board matrix
  #       0     1     2
  # 0 [ dead, dead, dead ]
  # 1 [ dead, alive, dead ]
  # 2 [ dead, dead, dead ]

  def initialize(rows = 50, cols = 50)

    @rows = rows
    @cols = cols
    @cells = []
    @cell_grid = Array.new(rows) do |row|
      Array.new(cols) do |col|
        cell = Cell.new(col, row)
        @cells << cell
        cell
      end
    end
  end

  def live_neighbors(cell)
    live_neighbors = []
    # neighbor to the North
    if cell.y > 0
      canidate = self.cell_grid[cell.y - 1][cell.x]
      live_neighbors << canidate if canidate.alive?
    end

    # neighbor to the south
    if cell.y < (rows - 1)
      canidate = self.cell_grid[cell.y + 1][cell.x]
      live_neighbors << canidate if canidate.alive?
    end

    #neighbor to the east
    if cell.x < (cols - 1)
      canidate = self.cell_grid[cell.y][cell.x + 1]
      live_neighbors << canidate if canidate.alive?
    end

    # neighbor to the west
    if cell.x > 0
      canidate = self.cell_grid[cell.y][cell.x - 1]
      live_neighbors << canidate if canidate.alive?
    end

    # neighbor to the north east
    if cell.y > 0 && cell.x < (cols - 1)
      canidate = self.cell_grid[cell.y - 1][cell.x + 1]
      live_neighbors << canidate if canidate.alive?
    end

    # neighbor to the north west
    if cell.y > 0 && cell.x > 0
      candidate = self.cell_grid[cell.y - 1][cell.x - 1]
      live_neighbors << candidate if candidate.alive?
    end

    # neighbor to the south west
    if cell.y < (rows - 1 ) && cell.x > 0
      candidate = self.cell_grid[cell.y + 1][cell.x - 1]
      live_neighbors << candidate if candidate.alive?
    end

    # neighbor to the south east
    if cell.y < (rows - 1 ) && cell.x < (cols - 1)
      candidate = self.cell_grid[cell.y + 1][cell.x + 1]
      live_neighbors << candidate if candidate.alive?
    end

    live_neighbors
  end

  def randomly_populate
    cells.each do |cell|
      cell.alive = [true, false].sample
    end
  end

  def display(game)
    display = []
    game.board.cells.each do |cell|
      if cell.alive?
        display << 'x'
      else
        display << 'o'
      end
    end
    user_display = display.each_slice(50)
    user_display.each {|row| p row}
  end

  def live_count(game)
    game.board.cells.select {|cell| cell.alive?}.count
  end

end 
class Cell
  attr_accessor :alive, :x, :y

  def initialize(x=0, y=0)
    @alive = false
    @x = x
    @y = y
  end

  def alive?
    alive
  end

  def dead?
    !alive
  end

  def die!
    @alive = false
  end

  def revive!
    @alive = true
  end
end



