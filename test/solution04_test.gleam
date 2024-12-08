import gleeunit
import gleeunit/should
import solution04

pub fn main() {
  gleeunit.main()
}

const data = "MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX"

pub fn part1_test() {
  let result = solution04.part1(data)

  should.equal(result, "18")
}

pub fn part2_test() {
  let result = solution04.part2(data)

  should.equal(result, "9")
}
