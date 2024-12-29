import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile
import util

pub fn parse_data(data: String) -> List(Int) {
  string.split(data, " ")
  |> list.map(util.parse_int)
}

fn evolve(stones: List(Int)) -> List(Int) {
  list.flat_map(stones, fn(stone) {
    let stone_str = int.to_string(stone)
    case stone, string.length(stone_str) {
      0, _ -> [1]
      _, num_digits if num_digits % 2 == 0 -> {
        [
          util.parse_int(string.drop_start(stone_str, num_digits / 2)),
          util.parse_int(string.drop_end(stone_str, num_digits / 2)),
        ]
      }
      _, _ -> [stone * 2024]
    }
  })
}

fn part1_iter(stones: List(Int), iteration: Int) -> Int {
  case iteration {
    25 -> list.length(stones)
    _ -> part1_iter(evolve(stones), iteration + 1)
  }
}

pub fn part1(data: String) -> String {
  let stones = parse_data(data)

  part1_iter(stones, 0)
  |> int.to_string()
}

pub fn part2(_data: String) -> String {
  ""
}

pub fn run() {
  let assert Ok(data) = simplifile.read("./data/00.txt")

  io.println(part1(data))
  io.println(part2(data))
}
