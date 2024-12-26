import gleam/dict
import gleam/set
import gleeunit
import gleeunit/should
import solution06.{Coord, GameState, Up, parse_data, part1, part2}

pub fn main() {
  gleeunit.main()
}

pub fn parse_data_test() {
  let result =
    solution06.parse_data(
      "....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...",
    )

  should.equal(
    result,
    GameState(
      guard_coord: Coord(6, 4),
      guard_dir: Up,
      visited: dict.from_list([#(Coord(6, 4), set.from_list([Up]))]),
      obstacles: set.from_list([
        Coord(0, 4),
        Coord(1, 9),
        Coord(3, 2),
        Coord(4, 7),
        Coord(6, 1),
        Coord(7, 8),
        Coord(8, 0),
        Coord(9, 6),
      ]),
      bounds: Coord(9, 9),
      obstruction_coords: set.new(),
    ),
  )
}

pub fn base_case_test() {
  let initial_game_state =
    "....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#..."
    |> solution06.parse_data

  should.equal(part1(initial_game_state), "41")
  should.equal(part2(initial_game_state), "6")
}

pub fn simple_loop_test() {
  let initial_game_state =
    "....
....
#^.#
..#."
    |> parse_data

  should.equal(part1(initial_game_state), "3")
  should.equal(part2(initial_game_state), "1")
}

pub fn handle_literal_edge_case_test() {
  let initial_game_state =
    "...#
....
#^..
..#."
    |> parse_data

  should.equal(part1(initial_game_state), "3")
  should.equal(part2(initial_game_state), "0")
}
