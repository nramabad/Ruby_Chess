require_relative 'board'
require 'singleton'

class Piece

  attr_reader :color, :symbol, :pos

  def initialize(pos = nil, color = nil)
    @pos = pos
    @color = color
    @symbol = nil
  end

  def valid_moves
    moves.reject do |move|
      duped_board = Board.dup
      duped_board.move_piece(@pos, move)
      duped_board.in_check?(@color)
    end
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
    move_dirs.each do |dir|
      potential_pos = [@pos[0] + dir[0], @pos[1] + dir[1]]
      while Board.valid_pos?(potential_pos)
        results << potential_pos
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
      results << potential_pos if Board.valid_pos?(potential_pos)
    end

    results
  end
end

class Bishop < Piece
  include SlidingPiece

  def initialize(pos, color)
    super
    @symbol = :bishop
  end

  def move_dirs
    [[-1,-1], [-1,1], [1,-1], [1,1]]
  end

end

class Rook < Piece
  include SlidingPiece

  def initialize(pos, color)
    super
    @symbol = :rook
  end

  def move_dirs
    [[0,-1], [0,1], [1,0], [1,0]]
  end

end

class Queen < Piece
  include SlidingPiece

  def initialize(pos, color)
    super
    @symbol = :queen
  end

  def move_dirs
    [[-1,-1], [-1,1], [1,-1], [1,1], [0,-1], [0,1], [1,0], [-1,0]]
  end

end

class Knight < Piece
  include SteppingPiece

  def initialize(pos, color)
    super
    @symbol = :knight
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

  def initialize(pos, color)
    super
    @symbol = :king
  end

  def move_dirs
    [[-1,-1], [-1,1], [1,-1], [1,1], [0,-1], [0,1], [1,0], [-1,0]]
  end
end

class Pawn < Piece

  def initialize(pos, color)
    super
    @symbol = :pawn
  end

  def moves
    []
  end

end
