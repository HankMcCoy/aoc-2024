import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

pub type EquationData {
  EquationData(sum: Int, operands: List(Int))
}

type ParsedData =
  List(EquationData)

fn parse_operands(op_str: String) -> List(Int) {
  op_str
  |> string.split(" ")
  |> list.filter(fn(x) { !string.is_empty(x) })
  |> list.map(parse_int)
}

fn parse_int(str: String) -> Int {
  let assert Ok(val) = int.parse(string.trim(str))
  val
}

pub fn parse_data(data: String) -> ParsedData {
  data
  |> string.split("\n")
  |> list.map(fn(line) {
    case string.split(line, ":") {
      [sum, operands_str] ->
        EquationData(parse_int(sum), parse_operands(operands_str))
      _ -> panic
    }
  })
}

pub type OperatorType {
  Mult
  Add
}

type EquationUnit {
  Operand(Int)
  Operator(OperatorType)
}

fn apply_operators(
  equation_units: List(EquationUnit),
  running_total: Int,
) -> Int {
  case equation_units {
    [] -> running_total
    [Operand(val), ..rest] -> apply_operators(rest, val)
    [Operator(op), Operand(val), ..rest] ->
      case op {
        Mult -> apply_operators(rest, running_total * val)
        Add -> apply_operators(rest, running_total + val)
      }
    _ -> panic
  }
}

pub fn get_operator_combos(
  len: Int,
  existing_operators: List(OperatorType),
) -> List(List(OperatorType)) {
  case len {
    0 -> [existing_operators]
    _ -> {
      let result =
        list.flatten([
          get_operator_combos(len - 1, list.append(existing_operators, [Mult])),
          get_operator_combos(len - 1, list.append(existing_operators, [Add])),
        ])
      result
    }
  }
}

fn could_be_true(equation: EquationData) -> Bool {
  let num_operators = list.length(equation.operands) - 1
  let operator_combos: List(List(OperatorType)) =
    get_operator_combos(num_operators, [])

  list.any(operator_combos, fn(operator_combo) {
    let eq_units =
      list.interleave([
        list.map(equation.operands, fn(o) { Operand(o) }),
        list.map(operator_combo, fn(o) { Operator(o) }),
      ])
    apply_operators(eq_units, 0) == equation.sum
  })
}

pub fn part1(data: String) -> String {
  parse_data(data)
  |> list.filter(could_be_true)
  |> list.map(fn(x) { x.sum })
  |> int.sum
  |> int.to_string
}

pub fn part2(data: String) -> String {
  ""
}

pub fn run() {
  let assert Ok(data) = simplifile.read("./data/07.txt")

  io.println(part1(data))
  io.println(part2(data))
}
