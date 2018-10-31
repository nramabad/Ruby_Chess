require "colorize"
require_relative "cursor"
require_relative "board"

class Display

  attr_reader :cursor

  def initialize(board)
    @board = board
    @cursor = Cursor.new([0,0], board)
  end

  def render
    @board.pieces.each_with_index do |row, i|
      row.each_with_index do |piece, j|

        if [i, j] == @cursor.cursor_pos && @cursor.selected
          print " #{piece.symbol} ".colorize(:color => piece.color, :background => :blue)
        elsif [i, j] == @cursor.cursor_pos
          print " #{piece.symbol} ".colorize(:color => piece.color, :background => :red)
        elsif (i + j).even?
          print " #{piece.symbol} ".colorize(:color => piece.color, :background => :yellow)
        else
          print " #{piece.symbol} ".colorize(:color => piece.color, :background => :light_black)
        end
      end
      puts
    end

    nil
  end





end
