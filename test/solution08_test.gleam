import cache
import gleam/dict
import gleam/set
import gleeunit
import gleeunit/should
import solution08.{ParsedData, get_candidate_antinodes, parse_data, part1, part2}
import util.{Coord}

pub fn main() {
  gleeunit.main()
}

pub fn parse_data_test() {
  let data =
    "............
 ........0...
 .....0......
 .......0....
 ....0.......
 ......A.....
 ............
 ............
 ........A...
 .........A..
 ............
 ............"

  should.equal(
    parse_data(data),
    ParsedData(
      antennas: dict.from_list([
        #("0", [Coord(1, 8), Coord(2, 5), Coord(3, 7), Coord(4, 4)]),
        #("A", [Coord(5, 6), Coord(8, 8), Coord(9, 9)]),
      ]),
      size: 12,
    ),
  )
}

pub fn get_candidate_antinodes_test() {
  should.equal(get_candidate_antinodes(#(Coord(10, 12), Coord(32, 10))), [
    Coord(-12, 14),
    Coord(54, 8),
  ])
}

pub fn part1_test() {
  let data =
    "............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............"

  should.equal(part1(data), "14")
}

pub fn part2_test() {
  let data = ""

  should.equal(part2(data), "")
}