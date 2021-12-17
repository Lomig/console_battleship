# frozen_string_literal: true

class Ship
  SHIP_SIZE = {
    carrier: 5,
    battleship: 4,
    cruiser: 3,
    submarine: 3,
    destroyer: 2
  }.freeze

  attr_reader :parts, :size
  private attr_reader :boat, :type, :direction

  def initialize(boat:)
    @boat = boat
    @size = SHIP_SIZE[boat]
  end

  def sunk? = @parts.all?(&:hit?)

  def to_s
    "\e[32m#{boat.to_s.capitalize}\e[0m (size: #{size})"
  end

  def deploy!(direction:)
    types = Hash.new(:middle).merge({ 0 => :head, (size - 1) => :tail })

    @parts = size.times.with_object([]) do |n, array|
      array << Part.new(ship: self, type: types[n], direction: direction)
    end
  end
end
