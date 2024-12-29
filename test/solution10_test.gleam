import gleam/dict
import gleam/set
import gleeunit
import gleeunit/should
import solution10.{parse_data, part1, part2}

pub fn main() {
  gleeunit.main()
}

pub fn parse_data_test() {
  let data =
    "890
781
874"

  should.equal(parse_data(data), [[8, 9, 0], [7, 8, 1], [8, 7, 4]])
}

pub fn part1_test() {
  let data =
    "89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732"

  should.equal(part1(data), "36")
}

pub fn part2_test() {
  let data = ""

  should.equal(part2(data), "")
}
