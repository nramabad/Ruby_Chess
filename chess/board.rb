require_relative 'piece'

class Board
  attr_accessor :pieces

  def initialize
    @pieces = []
    black_row = [Rook.new([0,0], :black), Knight.new([0,1], :black), Bishop.new([0,2], :black), King.new([0,3], :black)]
    black_row += [Queen.new([0,4], :black), Bishop.new([0,5], :black), Knight.new([0,6], :black), Rook.new([0,7], :black)]
    black_pawns = Array.new(8)
    (0..7).each { |i| black_pawns[i] = Pawn.new([1, i], :black) }
    empty_rows = Array.new(4, Array.new(8, NullPiece.instance))
    white_pawns = Array.new(8)
    (0..7).each { |i| white_pawns[i] = Pawn.new([6, i], :white) }
    white_row = [Rook.new([7,0], :white), Knight.new([7,1], :white), Bishop.new([7,2], :white), Queen.new([7,3], :white)]
    white_row += [King.new([7,4], :white), Bishop.new([7,5], :white), Knight.new([7,6], :white), Rook.new([7,7], :white)]
    @pieces << black_row
    @pieces << black_pawns
    @pieces += empty_rows
    @pieces << white_pawns
    @pieces << white_row
  end

  def move_piece(start_pos, end_pos)
    raise "No piece at position." if self[start_pos] == nil
    raise "End position is not a valid move." unless valid_moves(end_pos)
    self[end_pos] = self[start_pos]
    self[start_pos] = nil
  end

  def [](pos)
    @pieces[pos[0]][pos[1]]
  end

  def []=(pos, value)
    @pieces[pos[0]][pos[1]] = value
  end

  def self.valid_pos?(pos)
    pos[0].between?(0,7) && pos[1].between?(0,7)
  end

  def in_check?(color)
    opposite_player_pieces(color).each do |piece|
      piece.moves.each {|move| return true if move == find_king(color)}
    end
    false
  end

  def find_king(color)
    (0..7).each do |row|
      @pieces[row].each do |piece|
        return piece.pos if piece.color == color && piece.symbol == :king
      end
    end
  end

  def player_pieces(color)
    my_pieces = []
    (0..7).each do |row|
      @pieces[row].each do |piece|
        my_pieces << piece if piece.color == color
      end
    end
    my_pieces
  end

  def opposite_player_pieces(color)
    color = (color == :white ? :black : :white)
    player_pieces(color)
  end

  def checkmate?(color)
    in_check?(color) && player_pieces(color).all? {|piece| piece.valid_moves.empty?}
  end



end
