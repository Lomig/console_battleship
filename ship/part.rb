# frozen_string_literal: true

class Ship
  class Part
    attr_reader :type, :direction
    private attr_reader :ship

    def initialize(ship:, type:, direction:)
      @ship = ship
      @type = type
      @direction = direction
      @hit = false
    end

    def hit? = @hit

    def hit!
      is_already_hit = @hit
      @hit = true

      return :already_hit if is_already_hit
      return :sunk if ship.sunk?

      :hit
    end
  end
end
