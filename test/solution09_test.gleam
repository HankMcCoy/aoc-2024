import ary
import gleam/option.{None, Some}
import gleeunit
import gleeunit/should
import solution09.{parse_data, part1, part2}

pub fn main() {
  gleeunit.main()
}

pub fn parse_data_test() {
  should.equal(parse_data("1"), ary.from_list([Some(0)]))
  should.equal(
    parse_data("211"),
    ary.from_list([Some(0), Some(0), None, Some(1)]),
  )

  should.equal(
    parse_data("2333133121414131402"),
    ary.from_list([
      Some(0),
      Some(0),
      None,
      None,
      None,
      Some(1),
      Some(1),
      Some(1),
      None,
      None,
      None,
      Some(2),
      None,
      None,
      None,
      Some(3),
      Some(3),
      Some(3),
      None,
      Some(4),
      Some(4),
      None,
      Some(5),
      Some(5),
      Some(5),
      Some(5),
      None,
      Some(6),
      Some(6),
      Some(6),
      Some(6),
      None,
      Some(7),
      Some(7),
      Some(7),
      None,
      Some(8),
      Some(8),
      Some(8),
      Some(8),
      Some(9),
      Some(9),
    ]),
  )
}

pub fn part1_test() {
  should.equal(part1("233"), "9")
  should.equal(part1("2333133121414131402"), "1928")
}

pub fn part2_test() {
  let data = ""

  should.equal(part2(data), "")
}
