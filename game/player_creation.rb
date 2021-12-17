# frozen_string_literal: true

class Game
  class PlayerCreation
    def self.execute(**args)
      new(**args).execute
    end

    def initialize(id:, size:, fleet:, views:)
      @id = id
      @size = size
      @fleet = fleet
      @views = views
    end

    def execute
      name = views.interface.ask_for_name(id: id)
      player_battlefield = Battelfield.new(size: size)
      player_fleet = create_fleet

      deploy_fleet_on_battlefield(player_name: name, fleet: player_fleet, battlefield: player_battlefield)

      Player.new(name: name, fleet: player_fleet, battlefield: player_battlefield)
    end

    private

    attr_reader :id, :views, :size, :fleet

    def create_fleet
      fleet.each_with_object([]) do |(name, count), fleet_array|
        count.times { fleet_array << Ship.new(boat: name) }
      end
    end

    def deploy_fleet_on_battlefield(player_name:, fleet:, battlefield:)
      views.interface.warning_secret
      fleet.each { |ship| deploy(player_name: player_name, ship: ship, battlefield: battlefield) }
    end

    def deploy(player_name:, ship:, battlefield:)
      loop do
        column, line, direction = interact_with_player(player_name: player_name, ship: ship, battlefield: battlefield)

        ship.deploy!(direction: direction)
        break if battlefield.deploy(ship: ship, line: line, column: column, direction: direction) == :deployed

        views.interface.error_deployement
      end
    end

    def interact_with_player(player_name:, ship:, battlefield:)
      views.battlefield.draw(field: battlefield.field, size: size, type: :main)
      column, line = views.interface.ask_for_ship_position(player_name: player_name, ship: ship)
      direction = views.interface.ask_for_ship_direction

      [column, line, direction]
    end
  end
end
