import gleam/dict
import gleam/set
import gleeunit
import gleeunit/should
import solution10.{parse_data, part1, part2}

pub fn main() {
  gleeunit.main()
}

pub fn parse_data_test() {
  let data = ""

  should.equal(parse_data(data), Nil)
}

pub fn part1_test() {
  let data = ""

  should.equal(part1(data), "")
}

pub fn part2_test() {
  let data = ""

  should.equal(part2(data), "")
}
