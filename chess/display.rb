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
      row.each_with_index do |col, j|
        if [i, j] == @cursor.cursor_pos && @cursor.selected
           print "col | ".colorize(:blue)
        elsif [i, j] == @cursor.cursor_pos
           print "col | ".colorize(:yellow)
        else
           print "col | "
        end 
      end
      puts
    end

    nil
  end





end
