class Knight < Pieces

  def initialize(pos, color)
    super(pos, color)
  end

  def to_s
    @color == :white ? "\u2658 " : "\u265E "
  end

  def path(end_position)
    return [] unless possible_destination?(end_position)
    [end_position]
  end

  def possible_destination?(destination)
    deltas = calculate_coords_deltas(destination)

    # Can't move to same square
    # Knight's move in Ls
    deltas != [0, 0] && deltas[0].abs + deltas[1].abs == 3
  end
end