class King < Pieces

  def initialize(pos, color)
    super(pos, color)
  end

  def path(end_position)
    return [] unless possible_destination?(end_position)
    [end_position]
  end

  def possible_destination?(destination)
    deltas = calculate_coords_deltas(destination)
    # Kings can only move to adjacent squares
    deltas != [0, 0] && (deltas[0].abs < 2) && (deltas[1].abs < 2)
  end

  def to_s
    @color == :white ? "\u2654 " : "\u265A "
  end
end