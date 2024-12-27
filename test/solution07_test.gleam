import cache
import gleeunit
import gleeunit/should
import solution07.{
  Add, EquationData, Mult, get_operator_combos, parse_data, part1, part2,
}

pub fn main() {
  gleeunit.main()
}

pub fn get_operator_combos_test() {
  use cache <- cache.create()
  should.equal(get_operator_combos([Mult, Add], 2, cache), [
    [Mult, Mult],
    [Mult, Add],
    [Add, Mult],
    [Add, Add],
  ])
}

pub fn parse_data_test() {
  let data =
    "190: 10 19
 3267: 81 40 27
 83: 17 5
 156: 15 6
 7290: 6 8 6 15
 161011: 16 10 13
 192: 17 8 14
 21037: 9 7 18 13
 292: 11 6 16 20"

  should.equal(parse_data(data), [
    EquationData(190, [10, 19]),
    EquationData(3267, [81, 40, 27]),
    EquationData(83, [17, 5]),
    EquationData(156, [15, 6]),
    EquationData(7290, [6, 8, 6, 15]),
    EquationData(161_011, [16, 10, 13]),
    EquationData(192, [17, 8, 14]),
    EquationData(21_037, [9, 7, 18, 13]),
    EquationData(292, [11, 6, 16, 20]),
  ])
}

pub fn part1_test() {
  let data =
    "190: 10 19
 3267: 81 40 27
 83: 17 5
 156: 15 6
 7290: 6 8 6 15
 161011: 16 10 13
 192: 17 8 14
 21037: 9 7 18 13
 292: 11 6 16 20"

  should.equal(part1(data), "3749")
}

pub fn part2_test() {
  let data =
    "190: 10 19
 3267: 81 40 27
 83: 17 5
 156: 15 6
 7290: 6 8 6 15
 161011: 16 10 13
 192: 17 8 14
 21037: 9 7 18 13
 292: 11 6 16 20"

  should.equal(part2(data), "11387")
}
