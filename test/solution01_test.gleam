import gleeunit
import gleeunit/should
import solution01

pub fn main() {
  gleeunit.main()
}

const data = "3   4
4   3
2   5
1   3
3   9
3   3
"

pub fn parse_data_test() {
  let result = solution01.parse_data(data)

  should.equal(result.0, [3, 4, 2, 1, 3, 3])
  should.equal(result.1, [4, 3, 5, 3, 9, 3])
}

pub fn part1_test() {
  let result = solution01.part1(data)

  should.equal(result, "11")
}

pub fn part2_test() {
  let result = solution01.part2(data)

  should.equal(result, "31")
}
