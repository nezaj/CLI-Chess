class Bishop < Pieces

  def initialize(pos, color)
    super(pos, color)
  end

  def to_s
    @color == :white ? "\u2657 " : "\u265D "
  end

  def possible_destination?(destination)
    deltas = calculate_coords_deltas(destination)

    # Bishops move diagonally
    deltas != [0, 0] && deltas[0].abs == deltas[1].abs
  end
end