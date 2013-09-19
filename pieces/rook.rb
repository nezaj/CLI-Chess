class Rook < Pieces

  def initialize(pos, color)
    super(pos, color)
  end

  def possible_destination?(destination)
    deltas = calculate_coords_deltas(destination)

    # Can't move to same square
    # Rooks move either horizontally or vertically
    deltas != [0, 0] && deltas.include?(0)
  end

  def to_s
    @color == :white ? "\u2656 " : "\u265C "
  end
end