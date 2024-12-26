import gleam/int
import gleam/io
import gleam/list
import gleam/option.{Some}
import gleam/order
import gleam/string
import simplifile
import util.{get_at, index_of, parse_int}

pub type Rule {
  Rule(before: Int, after: Int)
}

type Page =
  Int

fn parse_rule(line: String) -> Rule {
  let assert Ok(#(before_str, after_str)) = string.split_once(line, "|")
  Rule(before: parse_int(before_str), after: parse_int(after_str))
}

pub fn parse_update(line: String) -> List(Page) {
  line
  |> string.split(",")
  |> list.map(parse_int)
}

pub fn parse_data(data: String) -> #(List(Rule), List(List(Page))) {
  let lines = string.split(data, "\n")

  let assert #(rule_lines, [_empty_line, ..update_lines]) =
    list.split_while(lines, fn(a) { a != "" })

  #(list.map(rule_lines, parse_rule), list.map(update_lines, parse_update))
}

pub fn obeys_rule(update: List(Page), rule: Rule) -> Bool {
  case index_of(update, rule.before), index_of(update, rule.after) {
    Some(idx_before), Some(idx_after) -> idx_before < idx_after
    _, _ -> True
  }
}

fn obeys_all_rules(update: List(Page), rules: List(Rule)) -> Bool {
  list.all(rules, obeys_rule(update, _))
}

fn get_middle_page(pages: List(Page)) -> Int {
  let assert Ok(middle_idx) = int.floor_divide(list.length(pages), 2)
  let assert Some(middle_page) = get_at(pages, middle_idx)
  middle_page
}

pub fn part1(data: String) -> String {
  let #(rules, updates) = parse_data(data)

  updates
  |> list.filter(obeys_all_rules(_, rules))
  |> list.map(get_middle_page)
  |> int.sum
  |> int.to_string
}

fn reorder(update: List(Page), rules: List(Rule)) -> List(Page) {
  list.sort(update, fn(first, second) {
    case obeys_all_rules([first, second], rules) {
      True -> order.Lt
      False -> order.Gt
    }
  })
}

pub fn part2(data: String) -> String {
  let #(rules, updates) = parse_data(data)

  updates
  |> list.filter(fn(update) { !obeys_all_rules(update, rules) })
  |> list.map(reorder(_, rules))
  |> list.map(get_middle_page)
  |> int.sum
  |> int.to_string
}

pub fn run() {
  let assert Ok(data) = simplifile.read("./data/05.txt")
  io.println(part1(data))
  io.println(part2(data))
}
