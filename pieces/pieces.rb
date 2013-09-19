class Pieces

  attr_accessor :position, :color

  def initialize(pos, color)
    @position = pos
    @color = color
  end

  def calculate_coords_deltas(destination)
    x1, y1 = self.position
    x2, y2 = destination
    difference = [x2 - x1, y2 - y1]
  end

  def path(end_position)
    return [] unless possible_destination?(end_position)

    dx, dy = calculate_coords_deltas(end_position)
    x,  y = @position

    path = []
    x_direction = dx > 0 ? 1 : -1
    y_direction = dy > 0 ? 1 : -1

    x_direction = 0 if dx == 0
    y_direction = 0 if dy == 0

    found = false
    until found
      x = x + x_direction
      y = y + y_direction
      new_position = [x, y]

      path << new_position

      found = true if new_position == end_position

    end
    path
  end

  def to_s
    "_"
  end
end

