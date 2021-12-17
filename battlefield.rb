# frozen_string_literal: true

#       ┌───┬───┬───┐
#       │ A │ B │ C │
# ┌─────┼───┼───┼───┤
# │   I │ 0 │ 1 │ 2 │
# ├─────┼───┼───┼───┤
# │  II │ 3 │ 4 │ 5 │
# ├─────┼───┼───┼───┤
# │ III │ 6 │ 7 │ 8 │
# └─────┴───┴───┴───┘

class Battelfield
  attr_reader :field, :size
  private attr_reader :direction_offsets

  def initialize(size:)
    @size = size
    @field = Array.new(size**2)

    @direction_offsets = {
      north: size,
      east: -1,
      south: -size,
      west: 1
    }.freeze
  end

  def deploy(ship:, line:, column:, direction:)
    column = column.downcase.ord - 97
    cell = column + size * (line - 1)
    direction_offset = direction_offsets[direction]

    return unless position_valid?(zone: ship.size, cell: cell, direction_offset: direction_offset)

    place_ship_on_field(ship: ship, cell: cell, direction_offset: direction_offset)
    :deployed
  end

  def shoot(line:, column:)
    column = column.downcase.ord - 97
    cell = column + size * (line - 1)
    return unless position_valid?(cell: cell)

    return missed(cell: cell) unless field[cell].is_a?(Ship::Part)

    field[cell].hit!
  end

  private

  def position_valid?(cell:, zone: 1, direction_offset: 0)
    rear_position = cell + (zone - 1) * direction_offset
    return false unless inside_field?(cell: cell, rear_position: rear_position)

    return true if direction_offset.zero?

    correctly_oriented?(cell: cell, rear_position: rear_position) &&
      on_free_cells?(cell: cell, zone: zone, direction_offset: direction_offset)
  end

  def inside_field?(cell:, rear_position:)
    end_of_battlefield = size**2
    return false if cell.negative? || cell >= end_of_battlefield
    return false if rear_position.negative? || rear_position >= end_of_battlefield

    true
  end

  def correctly_oriented?(cell:, rear_position:)
    cell % size == rear_position % size || cell / size == rear_position / size
  end

  def on_free_cells?(cell:, zone:, direction_offset:)
    zone.times.none? { |n| field[cell + n * direction_offset] }
  end

  def place_ship_on_field(ship:, cell:, direction_offset:)
    ship.parts.each_with_index { |part, n| field[cell + n * direction_offset] = part }
  end

  def missed(cell:)
    field[cell] = "\e[32m•\e[0m"
    :missed
  end
end
