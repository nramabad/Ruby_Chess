require_relative 'board'
require 'singleton'

class Piece

  attr_reader :color, :symbol, :pos

  def initialize(pos = nil, color = nil, board = nil)
    @board = board
    @pos = pos
    @color = color
    @symbol = " "
  end

  def valid_moves
    result = []
    moves.each do |move|
      duped_board = @board.dup
      duped_board.move_piece(@pos, move)
      unless duped_board.in_check?(@color)
        result << move
      end
    end
    result
  end

  def moves
  end
end

class NullPiece < Piece
  include Singleton
end

module SlidingPiece

  def moves
    results = []
    opposite_color = (@color == :black ? :white : :black)
    move_dirs.each do |dir|
      potential_pos = [@pos[0] + dir[0], @pos[1] + dir[1]]
      while @board.valid_pos?(potential_pos) && @board[potential_pos].color != @color
        results << potential_pos
        break if @board[potential_pos].color == opposite_color
        potential_pos = [potential_pos[0] + dir[0], potential_pos[1] + dir[1]]
      end
    end

    results
  end

end

module SteppingPiece
  def moves
    results = []
    move_dirs.each do |dir|
      potential_pos = [@pos[0] + dir[0], @pos[1] + dir[1]]
      if @board.valid_pos?(potential_pos) && @board[potential_pos].color != @color
        results << potential_pos
      end
    end

    results
  end
end

class Bishop < Piece
  include SlidingPiece

  def initialize(pos, color, board)
    super
    @symbol = :♝
  end

  def move_dirs
    [[-1,-1], [-1,1], [1,-1], [1,1]]
  end

end

class Rook < Piece
  include SlidingPiece

  def initialize(pos, color, board)
    super
    @symbol = :♜
  end

  def move_dirs
    [[0,-1], [0,1], [1,0], [1,0]]
  end

end

class Queen < Piece
  include SlidingPiece

  def initialize(pos, color, board)
    super
    @symbol = :♛
  end

  def move_dirs
    [[-1,-1], [-1,1], [1,-1], [1,1], [0,-1], [0,1], [1,0], [-1,0]]
  end

end

class Knight < Piece
  include SteppingPiece

  def initialize(pos, color, board)
    super
    @symbol = :♞
  end

  def move_dirs
    [
      [2, 1], [2, -1], [-2, 1], [-2, -1],
      [1, 2], [1, -2], [-1, 2], [-1, -2]
    ]
  end

end

class King < Piece
  include SteppingPiece

  def initialize(pos, color, board)
    super
    @symbol = :♚
  end

  def move_dirs
    [[-1,-1], [-1,1], [1,-1], [1,1], [0,-1], [0,1], [1,0], [-1,0]]
  end
end

class Pawn < Piece

  def initialize(pos, color, board)
    super
    @symbol = :♟
  end

  def moves
    []
  end

end
