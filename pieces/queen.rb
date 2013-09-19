class Queen < Pieces

  def initialize(pos, color)
    super(pos, color)
  end

  def possible_destination?(destination)
    deltas = calculate_coords_deltas(destination)
    # Can't move to same square
    # Queens can move like rooks or bishops
    deltas != [0, 0] && (deltas.include?(0) || (deltas[0].abs == deltas[1].abs))
  end

  def to_s
    @color == :white ? "\u2655 " : "\u265B "
  end
end

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