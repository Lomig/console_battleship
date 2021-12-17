# frozen_string_literal: true

require "ostruct"
require_relative "game"
require_relative "game/player_creation"
require_relative "player"
require_relative "ship"
require_relative "ship/part"
require_relative "battlefield"
require_relative "views/interface"
require_relative "views/battlefield"

views = OpenStruct.new(
  battlefield: Views::Battlefield.new,
  interface: Views::Interface.new
)

Game.new(views: views).run
