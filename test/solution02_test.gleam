import gleeunit
import gleeunit/should
import solution02

pub fn main() {
  gleeunit.main()
}

const data = "7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
"

pub fn parse_data_test() {
  let result = solution02.parse_data(data)

  should.equal(result, [
    [7, 6, 4, 2, 1],
    [1, 2, 7, 8, 9],
    [9, 7, 6, 2, 1],
    [1, 3, 2, 4, 5],
    [8, 6, 4, 4, 1],
    [1, 3, 6, 7, 9],
  ])
}

pub fn part1_test() {
  let result = solution02.part1(data)

  should.equal(result, "2")
}

pub fn part2_test() {
  let result = solution02.part2(data)

  should.equal(result, "4")
}
