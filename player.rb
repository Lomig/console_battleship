# frozen_string_literal: true

class Player
  attr_reader :battlefield, :radar
  private attr_reader :name, :fleet

  def initialize(name:, fleet:, battlefield:)
    @name = name.capitalize
    @fleet = fleet

    @battlefield = battlefield
    @radar = Battelfield.new(size: battlefield.size)
  end

  def to_s = name

  def check_status_and_report(to:)
    game = to

    game.gameover! if lost?
  end

  def shoot(column:, line:) = battlefield.shoot(column: column, line: line)

  private

  def lost? = fleet.all?(&:sunk?)
end
