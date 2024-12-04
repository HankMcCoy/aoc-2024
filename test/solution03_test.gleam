import gleeunit
import gleeunit/should
import solution03

pub fn main() {
  gleeunit.main()
}

pub fn part1_test() {
  let data =
    "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
  let result = solution03.part1(data)

  should.equal(result, "161")
}

pub fn part2_test() {
  let data =
    "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
  let result = solution03.part2(data)

  should.equal(result, "48")
}
