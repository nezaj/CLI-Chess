class Pawn < Pieces

  def initialize(pos, color)
    super(pos, color)
  end

  def to_s
    @color == :white ? "\u2659 " : "\u265F "
  end

  def path(end_position)
    return [] unless possible_destination?(end_position)
    [end_position]
  end

  def possible_destination?(destination)
    deltas = calculate_coords_deltas(destination)

    # Allows all movements within one square left or right
    return false unless deltas[1].abs < 2

    # Restricts movements to two squares forward if in initial row
    return deltas[0].between?(-2, -1) if @color == :white && @position[0] == 6
    return deltas[0].between?(1, 2) if @color == :black && @position[0] == 1

    # Restricts movements to one square forward otherwise
    @color == :white ? deltas[0] == -1 : deltas[0] == 1
  end
end