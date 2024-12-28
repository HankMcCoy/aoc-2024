import gleam/option.{None, Some}
import gleeunit
import gleeunit/should
import solution09.{FileBlock, Space, parse_data, part1, part2}

pub fn main() {
  gleeunit.main()
}

pub fn parse_data_test() {
  let data = "2333133121414131402"

  should.equal(parse_data(data), [
    FileBlock(id: 0, size: 2),
    Space(size: 3),
    FileBlock(id: 1, size: 3),
    Space(size: 3),
    FileBlock(id: 2, size: 1),
    Space(size: 3),
    FileBlock(id: 3, size: 3),
    Space(size: 1),
    FileBlock(id: 4, size: 2),
    Space(size: 1),
    FileBlock(id: 5, size: 4),
    Space(size: 1),
    FileBlock(id: 6, size: 4),
    Space(size: 1),
    FileBlock(id: 7, size: 3),
    Space(size: 1),
    FileBlock(id: 8, size: 4),
    Space(size: 0),
    FileBlock(id: 9, size: 2),
  ])
}

pub fn part1_test() {
  let data = "2333133121414131402"

  should.equal(part1(data), "1928")
}

pub fn part2_test() {
  let data = ""

  should.equal(part2(data), "")
}
