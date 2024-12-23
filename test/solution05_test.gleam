import gleam/dict
import gleam/io
import gleam/set
import gleeunit
import gleeunit/should
import solution05.{Rule, obeys_rule, parse_data, parse_update}

pub fn main() {
  gleeunit.main()
}

const data = "47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47"

pub fn parse_update_test() {
  let update = parse_update("10,20,30")

  should.equal(update, [10, 20, 30])
}

pub fn obeys_rule_test() {
  let update = parse_update("1,2,3")

  should.equal(solution05.obeys_rule(update, Rule(1, 2)), True)
  should.equal(solution05.obeys_rule(update, Rule(2, 1)), False)
}

pub fn part1_test() {
  let result = solution05.part1(data)

  should.equal(result, "143")
}

pub fn part2_test() {
  let result = solution05.part2(data)

  should.equal(result, "123")
}
