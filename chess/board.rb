require_relative 'piece'

class Board
  attr_accessor :pieces

  def initialize
    @pieces = []
    black_row = [Rook.new([0,0], :black, self), Knight.new([0,1], :black, self), Bishop.new([0,2], :black, self), Queen.new([0,3], :black, self)]
    black_row += [King.new([0,4], :black, self), Bishop.new([0,5], :black,self), Knight.new([0,6], :black, self), Rook.new([0,7], :black, self)]
    black_pawns = Array.new(8)
    (0..7).each { |i| black_pawns[i] = Pawn.new([1, i], :black, self) }
    empty_rows = Array.new(4) {Array.new(8, NullPiece.instance)}
    white_pawns = Array.new(8)
    (0..7).each { |i| white_pawns[i] = Pawn.new([6, i], :white, self) }
    white_row = [Rook.new([7,0], :white, self), Knight.new([7,1], :white, self), Bishop.new([7,2], :white, self), King.new([7,3], :white, self)]
    white_row += [Queen.new([7,4], :white, self), Bishop.new([7,5], :white, self), Knight.new([7,6], :white, self), Rook.new([7,7], :white, self)]
    @pieces << black_row
    @pieces << black_pawns
    @pieces += empty_rows
    @pieces << white_pawns
    @pieces << white_row
  end

  def move_piece(start_pos, end_pos)
    raise "No piece at position." if self[start_pos] == NullPiece.instance
    # raise "End position is not a valid move." unless self[start_pos].valid_moves.include?(end_pos)
    self[end_pos] = self[start_pos]
    self[start_pos] = NullPiece.instance
  end

  def [](pos)
    @pieces[pos[0]][pos[1]]
  end

  def []=(pos, value)
    @pieces[pos[0]][pos[1]] = value
  end

  def valid_pos?(pos)
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

  def dup
    dupped_board = Board.new
    dupped_board.pieces = deep_dup(self.pieces, dupped_board)
    dupped_board
  end

  def deep_dup(old_pieces, dupped_board)
    old_pieces.map do |el|
      if el.is_a?(Array)
        deep_dup(el, dupped_board)
      else
        el.class == NullPiece ? NullPiece.instance : el.class.new(el.pos, el.color, dupped_board)
      end
    end
  end

end
