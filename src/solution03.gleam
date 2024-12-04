import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option, Some}
import gleam/regexp
import gleam/string
import simplifile

pub fn part1(data: String) -> String {
  let assert Ok(re) = regexp.from_string("mul\\(([0-9]+),([0-9]+)\\)")
  regexp.scan(with: re, content: data)
  |> list.map(fn(match) {
    case match {
      regexp.Match(_content, [Some(str1), Some(str2)]) -> #(str1, str2)
      _ -> panic
    }
  })
  |> list.map(fn(strs) {
    case int.parse(strs.0), int.parse(strs.1) {
      Ok(num1), Ok(num2) -> num1 * num2
      _, _ -> panic
    }
  })
  |> list.fold(from: 0, with: int.add)
  |> int.to_string
}

type State {
  State(is_mult_active: Bool, running_total: Int)
}

type Command {
  Mult(operand1: Int, operand2: Int)
  Do
  Dont
}

const initial_state = State(is_mult_active: True, running_total: 0)

fn parse_mult_command(submatches: List(Option(String))) -> Command {
  let strs = case submatches {
    [_, Some(str1), Some(str2)] -> #(str1, str2)
    _ -> panic
  }

  case int.parse(strs.0), int.parse(strs.1) {
    Ok(num1), Ok(num2) -> Mult(num1, num2)
    _, _ -> panic
  }
}

fn parse_command(match: regexp.Match) -> Command {
  case match {
    regexp.Match("mul" <> _rest, submatches) -> parse_mult_command(submatches)
    regexp.Match("do()", _) -> Do
    regexp.Match("don't()", _) -> Dont
    _ -> panic
  }
}

fn apply_command(state: State, cmd: Command) {
  case state, cmd {
    _, Do -> State(..state, is_mult_active: True)
    _, Dont -> State(..state, is_mult_active: False)
    State(is_mult_active: True, running_total: _), Mult(op1, op2) ->
      State(..state, running_total: state.running_total + op1 * op2)
    State(is_mult_active: False, running_total: _), _ -> state
  }
}

const operator_re_strs = [
  "mul\\(([0-9]+),([0-9]+)\\)", "do\\(\\)", "don't\\(\\)",
]

pub fn part2(data: String) -> String {
  let assert Ok(re) =
    regexp.from_string("(" <> string.join(operator_re_strs, with: "|") <> ")")
  let matches = regexp.scan(with: re, content: data)
  let cmds: List(Command) = list.map(matches, parse_command)

  list.fold(over: cmds, from: initial_state, with: apply_command).running_total
  |> int.to_string
}

pub fn run() {
  let assert Ok(data) = simplifile.read("./data/03.txt")
  io.println(part1(data))
  io.println(part2(data))
}
