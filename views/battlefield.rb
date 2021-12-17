# frozen_string_literal: true

module Views
  class Battlefield
    SYMBOLS = {
      head: { north: "▲", south: "▼", west: "◀", east: "▶" },
      tail: { north: "◡", south: "◠", west: "◗", east: "◖" },
      middle: { north: "■", south: "■", west: "■", east: "■" }
    }.freeze

    SEPARATORS = {
      other: ["├─", "┼", "┤"],
      last: ["└─", "┴", "┘"]
    }.freeze

    TITLE = { main: "MY SHIPS", radar: "RADAR" }.freeze

    COLORS = { main: "\e[34m", radar: "\e[33m" }.freeze

    def draw(size:, field:, type:)
      field = format(field: field, type: type)
      color = COLORS[type]
      [
        intro(size: size, color: color, type: type),
        field_lines(size: size, field: field, color: color)
      ].join
        .then { |string| puts string }
    end

    private

    def format(field:, type:)
      field.map do |cell|
        next " " unless cell
        next cell if cell.is_a? String

        color = cell.hit? ? "\e[31m" : ""
        stop = cell.hit? ? "\e[0m" : ""
        next "#{color}#{SYMBOLS[cell.type][cell.direction]}#{stop}" unless type == :radar

        next " " unless cell.hit?

        "#{color}X#{stop}"
      end
    end

    def intro(size:, color:, type:)
      [
        "#{color}         ┌#{'───┬' * (size - 1)}───┐\n",
        "#{TITLE[type].rjust(8)} │#{header(size: size)}\n",
        "    ┌─#{'───┼' * size}───┤#{stop}\n"
      ].join
    end

    def header(size:)
      size.times.with_object([]) do |n, array|
        array << " #{(65 + n).chr} │"
      end.join
    end

    def field_lines(size:, field:, color:)
      field.each_slice(size)
           .with_index
           .with_object([]) do |(line, index), array|
        array << field_line(line: line, line_number: index + 1,
                            size: size, color: color)
      end
           .join("\n")
    end

    def field_line(line:, line_number:, size:, color:)
      [
        "#{color}    | #{line_number.to_s.rjust(2)} |#{stop}",
        "#{line_details(line: line, color: color)}\n",
        "#{color}#{endline(line_number: line_number, size: size)}#{stop}"
      ].join
    end

    def line_details(line:, color:)
      line.each_with_object([]) do |cell, array|
        array << " #{cell} #{color}|#{stop}"
      end.join
    end

    def endline(line_number:, size:)
      separators = line_number == size ? SEPARATORS[:last] : SEPARATORS[:other]
      inner_string = "───#{separators[1]}"

      "    #{separators[0]}#{inner_string * size}───#{separators[2]}"
    end

    def stop = "\e[0m"
  end
end
