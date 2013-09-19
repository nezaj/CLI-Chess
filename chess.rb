require './pieces/pieces.rb'
require './pieces/king.rb'
require './pieces/queen.rb'
require './pieces/rook.rb'
require './pieces/bishop.rb'
require './pieces/knight.rb'
require './pieces/pawn.rb'

class Board
  attr_accessor :board
  attr_reader :turn

  def initialize(turn = :white)
    @board = build_board
    @turn = turn
  end

  def build_board
    board = Array.new(8) { Array.new(8) }
    create_royalty
    board[7] = @WHITE_ROYALTY
    board[6] = place_pawns(6, :white)
    board[1] = place_pawns(1, :black)
    board[0] = @BLACK_ROYALTY
    board
  end

  def check?
    current_color = turn

    # get position of current players king
    king = @board.flatten.select { |square| (square.color == current_color &&
                                           square.class == King) unless square.nil? }.first
    # select other player's pieces
    enemies = @board.flatten.select { |square| (square.color != current_color) unless square.nil? }

    enemies.each do |enemy|
      threat = enemy.path(king.position)
      next if threat.empty?
      return true if clear_path?(threat)
    end

    false
  end

  def checkmate?
    return false unless check?

    new_board = deep_dup
    current_color = @turn

    # select our pieces
    friendlies = new_board.board.flatten.select { |square| square.color == current_color unless square.nil? }

    # iterate through our own pieces
    friendlies.each do |piece|
      7.times do |i|
        7.times do |j|
          coords = [piece.position, [i, j]]
          next unless valid_move?(coords)
          new_board.place_piece(piece.position, [i, j])
          piece.position = [i, j]

          unless new_board.check?
            return false
          end
        end
      end
    end

    true
  end

  def clear_path?(path)
    # No blocking pieces before end
    path.each do |pos|
      next if pos == path.last
      x, y = pos
      return false unless @board[x][y].nil?
    end
    true
  end

  def coordinates_exist?(coords)
    coords.each do |coord|
      return false unless coord[0].between?(0, 7)
      return false unless coord[1].between?(0, 7)
    end
    true
  end

  def create_royalty
    @BLACK_ROYALTY = [
      Rook.new(   [0, 0], :black),
      Knight.new( [0, 1], :black),
      Bishop.new( [0, 2], :black),
      Queen.new(  [0, 3], :black),
      King.new(   [0, 4], :black),
      Bishop.new( [0, 5], :black),
      Knight.new( [0, 6], :black),
      Rook.new(   [0, 7], :black)
    ]

    @WHITE_ROYALTY = [
      Rook.new(   [7, 0], :white),
      Knight.new( [7, 1], :white),
      Bishop.new( [7, 2], :white),
      Queen.new(  [7, 3], :white),
      King.new(   [7, 4], :white),
      Bishop.new( [7, 5], :white),
      Knight.new( [7, 6], :white),
      Rook.new(   [7, 7], :white)
    ]
  end

  def deep_dup
    board = Board.new(@turn)
    @board.each_with_index do |row, i|
      row.each_with_index do |square, j|
        square.nil? ? board.board[i][j] = nil : board.board[i][j] = square.dup
      end
    end
    board
  end

  def get_coords(input)
    input = input.split(", ")
    return nil unless input.length == 2

    # ["a2", "a4"] => ["2a", "4a"] need to switch for board
    input = input.map {|el| el.reverse }

    # Convert coordinates to match board
    coords = []
    input.each do |pos|
      x = 8 - pos[0].to_i
      y = pos[1].ord - "a".ord
      coords << [x, y]
    end

    return nil unless coordinates_exist?(coords)
    coords
  end

  def get_piece(pos)
    x, y = pos[0], pos[1]
    @board[x][y]
  end

  def next_turn
    @turn == :white ? @turn = :black : @turn = :white
  end

  def place_pawns(row, color)
    pawns = []
    8.times { |i| pawns << Pawn.new([row, i], color) }
    pawns
  end

  def place_piece(start_pos, end_pos)
    new_x, new_y = end_pos
    old_x, old_y = start_pos

    piece = @board[old_x][old_y]
    @board[old_x][old_y] = nil
    @board[new_x][new_y] = piece
  end

  def to_s
    @board.each_with_index do |row, i|
      print (8 - i)
      row.each_with_index do |piece, j|
        print "%2s" % "_" if piece.nil?
        print "%2s" % piece.to_s if piece
      end
      puts
    end
    ('a'..'h').to_a.each { |alpha| print "%2s" % alpha }
    puts
  end

  def valid_move?(coords)
    if coords.include?(nil)
      puts "Please enter valid coordinates (don't forget the comma)!"
      return false
    end

    start_pos, end_pos = coords
    current_piece = get_piece(start_pos)

    unless current_piece && current_piece.color == @turn
      puts "You need to select your own piece to move!"
      return false
    end

    path = current_piece.path(end_pos)

    if path.empty?
      puts "Invalid move for #{current_piece}!"
      return false
    end

    unless clear_path?(path)
      puts "Blocking piece"
      return false
    end

    # Check if friendly piece is at the end position
    other_piece = get_piece(end_pos)
    if other_piece && other_piece.color == current_piece.color
      puts "You cant take your own piece!"
      return false
    end

    # Pawns can move diagonal if other piece; can move vertical if not
    if current_piece.class == Pawn
      if (start_pos[1] == end_pos[1] && other_piece)
        puts "#{current_piece} can't go straight in..."
        return false
      end
      if (start_pos[1] != end_pos[1] && other_piece.nil?)
        puts "#{current_piece} move diagonal only to kill..."
        return false
      end

    end

    # Can't move into check
    new_board = deep_dup
    new_board.place_piece(start_pos, end_pos)
    if new_board.check?
      puts "You can't move into check"
      return false
    end

    true
  end

end

class Game
  attr_accessor :board

  def initialize
    @board = Board.new
  end

  def run
    until @board.checkmate?
      p @board
      puts "#{@board.turn.to_s}'s turn"
      puts "You are in check" if @board.check?
      print "Enter your move (ex: a2, a4): "

      start_pos, end_pos = @board.get_coords(gets.chomp)
      next unless @board.valid_move?([start_pos, end_pos])
      update_board(start_pos, end_pos)
    end
    p @board
    puts "Congratulations #{@board.next_turn}!"
  end

  def update_board(start_pos, end_pos)
    current_piece = @board.get_piece(start_pos)
    @board.place_piece(start_pos, end_pos)
    current_piece.position = end_pos
    @board.next_turn
  end
end

if __FILE__ == $PROGRAM_NAME
  chess = Game.new
  chess.run
end



