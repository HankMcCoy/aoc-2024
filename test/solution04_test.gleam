import gleeunit
import gleeunit/should
import solution04

pub fn main() {
  gleeunit.main()
}

pub fn part1_test() {
  let data =
    "MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX"
  let result = solution04.part1(data)

  should.equal(result, "18")
}

pub fn part2_test() {
  let data = ""
  let result = solution04.part2(data)

  should.equal(result, "")
}
