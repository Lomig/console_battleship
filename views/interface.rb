# frozen_string_literal: true

module Views
  class Interface
    RESULTS = {
      missed: "Missed",
      hit: "Hit",
      sunk: "Sunk",
      already_hit: "This target was already a wreck"
    }.freeze

    def ask_for_name(id:)
      puts "PLAYER #{id}, what's your name?"
      prompt
      gets.chomp
    end

    def warning_secret
      puts "---"
      puts "\e[36m!!! The other player should not look at the screen right now!\e[0m\n"
    end

    def ask_for_ship_position(player_name:, ship:)
      puts "\n--- \e[32m#{player_name}\e[0m"
      puts "Place the bow of a #{ship}:"
      prompt

      answer = gets.chomp.downcase.match(/\A([a-z]+)(\d+)\z/)

      return [answer[1], answer[2].to_i] if answer

      puts "Please enter valid coordinates!"
      ask_for_ship_position(player_name: player_name, ship: ship)
    end

    def ask_for_ship_direction
      puts "Where is this boat heading to? (North, South, West, East)"
      prompt

      answer = gets[0].downcase.to_sym
      { n: :north, e: :east, s: :south, w: :west }[answer] || ask_for_ship_direction
    end

    def error_deployement
      puts "Deployement failed! Please try again!\n"
    end

    def ask_for_coordinates(player:)
      puts "#{player}, where to aim? (exemple: B4)"
      prompt

      answer = gets.chomp.downcase.match(/\A([a-z]+)(\d+)\z/)
      return [answer[1], answer[2].to_i] if answer

      puts "Please enter valid coordinates!"
      ask_for_coordinates
    end

    def new_turn(player:)
      puts "----------------------------------------"
      puts "--#{player}: Let's play!"
      puts "----------------------------------------\n"
    end

    def announce_results(result:, player:)
      puts "#{player} shot: #{RESULTS[result]}!"
    end

    private

    def prompt
      print "\e[36m>\e[0m "
    end
  end
end
