# frozen_string_literal: true

class Game
  ARMADA = {
    carrier: 1,
    # battleship: 1,
    # cruiser: 1,
    # destroyer: 2,
    submarine: 2
  }.freeze

  private attr_accessor :views, :size, :gameover, :fleet, :players, :player_turn

  def initialize(views:, size: 10, fleet: ARMADA)
    @size = size
    @fleet = fleet
    @views = views

    @players = []
    @player_turn = rand(0..1)
  end

  def run
    players << Game::PlayerCreation.execute(id: 1, size: size, fleet: fleet, views: views)
    players << Game::PlayerCreation.execute(id: 2, size: size, fleet: fleet, views: views)

    gameplay_loop
  end

  def gameover!
    self.gameover = true
  end

  def next_player!
    self.player_turn = (player_turn + 1) % 2
  end

  def current_player = players[player_turn]

  def adversary = players[(player_turn + 1) % 2]

  private

  def gameover? = gameover

  def gameplay_loop
    loop do
      views.interface.new_turn(player: current_player)
      show_tactical_view
      result = shoot_adversary

      views.interface.announce_results(player: current_player, result: result)
      check_player_status

      break if gameover?

      next_player!
    end

    puts "#{adversary} has seen their fleet sunk!"
  end

  def show_tactical_view
    views.battlefield.draw(field: adversary.battlefield.field, size: size, type: :radar)
    views.battlefield.draw(field: current_player.battlefield.field, size: size, type: :main)
  end

  def shoot_adversary
    column, line = views.interface.ask_for_coordinates(player: current_player)
    adversary.shoot(column: column, line: line) || shoot
  end

  def check_player_status
    players.each { |player| player.check_status_and_report(to: self) }
  end
end
