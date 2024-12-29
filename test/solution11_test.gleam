import gleeunit
import gleeunit/should
import solution11.{parse_data, part1, part2}

pub fn main() {
  gleeunit.main()
}

pub fn parse_data_test() {
  let data = "773 79858 0 71 213357 2937 1 3998391"

  should.equal(parse_data(data), [
    773, 79_858, 0, 71, 213_357, 2937, 1, 3_998_391,
  ])
}

pub fn part1_test() {
  let data = "773 79858 0 71 213357 2937 1 3998391"

  should.equal(part1(data), "55312")
}

pub fn part2_test() {
  let data = "773 79858 0 71 213357 2937 1 3998391"

  should.equal(part2(data), "")
}
