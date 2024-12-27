import cache
import gleam/int
import gleam/io
import gleam/list.{Continue, Stop}
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
  Concat
}

type EquationUnit {
  Operand(Int)
  Operator(OperatorType)
}

fn equation_matches_sum(sum: Int, equation_units: List(EquationUnit)) -> Bool {
  let assert [Operand(start_value), ..rest] = equation_units
  let fold_result =
    list.fold_until(
      list.sized_chunk(rest, 2),
      start_value,
      fn(running_total, eq_unit_pair) {
        let assert [Operator(operator), Operand(next_value)] = eq_unit_pair
        let new_value = case operator {
          Mult -> running_total * next_value
          Add -> running_total + next_value
          Concat ->
            parse_int(int.to_string(running_total) <> int.to_string(next_value))
        }
        case new_value {
          _ if new_value > sum -> Stop(new_value)
          _ -> Continue(new_value)
        }
      },
    )

  fold_result == sum
}

pub fn get_operator_combos_core(
  operator_types: List(OperatorType),
  len: Int,
  existing_operators: List(OperatorType),
) -> List(List(OperatorType)) {
  case len {
    0 -> [existing_operators]
    _ -> {
      list.flatten(
        list.map(operator_types, fn(cur_op_type) {
          get_operator_combos_core(
            operator_types,
            len - 1,
            list.append(existing_operators, [cur_op_type]),
          )
        }),
      )
    }
  }
}

type OperatorComboCache =
  cache.Cache(#(List(OperatorType), Int), List(List(OperatorType)))

pub fn get_operator_combos(
  operator_types: List(OperatorType),
  len: Int,
  cache: OperatorComboCache,
) -> List(List(OperatorType)) {
  use <- cache.memoize(with: cache, this: #(operator_types, len))
  get_operator_combos_core(operator_types, len, [])
}

fn could_be_true(
  equation: EquationData,
  operator_types: List(OperatorType),
  cache: OperatorComboCache,
) -> Bool {
  let num_operators = list.length(equation.operands) - 1
  let operator_combos =
    get_operator_combos(operator_types, num_operators, cache)

  list.any(operator_combos, fn(operator_combo) {
    let eq_units =
      list.interleave([
        list.map(equation.operands, fn(o) { Operand(o) }),
        list.map(operator_combo, fn(o) { Operator(o) }),
      ])
    equation_matches_sum(equation.sum, eq_units)
  })
}

pub fn part1(data: String) -> String {
  use cache <- cache.create()
  parse_data(data)
  |> list.filter(could_be_true(_, [Mult, Add], cache))
  |> list.map(fn(x) { x.sum })
  |> int.sum
  |> int.to_string
}

pub fn part2(data: String) -> String {
  use cache <- cache.create()
  parse_data(data)
  |> list.filter(could_be_true(_, [Mult, Add, Concat], cache))
  |> list.map(fn(x) { x.sum })
  |> int.sum
  |> int.to_string
}

pub fn run() {
  let assert Ok(data) = simplifile.read("./data/07.txt")

  io.println(part1(data))
  io.println(part2(data))
}
