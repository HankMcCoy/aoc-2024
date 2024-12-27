import gleam/io
import simplifile

pub fn parse_data(_data: String) -> Nil {
  Nil
}

pub fn part1(_data: String) -> String {
  ""
}

pub fn part2(_data: String) -> String {
  ""
}

pub fn run() {
  let assert Ok(data) = simplifile.read("./data/00.txt")

  io.println(part1(data))
  io.println(part2(data))
}
