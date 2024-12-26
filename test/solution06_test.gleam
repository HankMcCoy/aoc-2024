import gleam/dict
import gleam/set
import gleeunit
import gleeunit/should
import solution06.{Coord, GameState, Up}

pub fn main() {
  gleeunit.main()
}

const data = "....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#..."

pub fn parse_data_test() {
  let result = solution06.parse_data(data)

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
      num_loop_obstacles: 0,
    ),
  )
}

pub fn part1_test() {
  let result =
    data
    |> solution06.parse_data
    |> solution06.get_final_game_state
    |> solution06.part1

  should.equal(result, "41")
}

pub fn part2_test() {
  let result =
    data
    |> solution06.parse_data
    |> solution06.get_final_game_state
    |> solution06.part2

  should.equal(result, "6")
}
