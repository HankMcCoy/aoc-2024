import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/regexp
import gleam/result.{unwrap}
import gleam/string
import simplifile

fn count_instances(data: List(a)) -> dict.Dict(a, Int) {
  list.fold(data, dict.new(), fn(counts, num) {
    dict.upsert(counts, num, fn(value) {
      case value {
        Some(count) -> count + 1
        None -> 1
      }
    })
  })
}

pub fn parse_data(data: String) -> #(List(Int), List(Int)) {
  let assert Ok(ws_re) = regexp.from_string(" +")

  string.split(data, on: "\n")
  |> list.filter(fn(x) { string.length(x) > 0 })
  |> list.map(fn(line) {
    let assert [str1, str2] = regexp.split(with: ws_re, content: line)
    let assert #(Ok(num1), Ok(num2)) = #(int.parse(str1), int.parse(str2))
    #(num1, num2)
  })
  |> list.unzip
}

pub fn part1(data: String) -> String {
  let #(list1, list2) = parse_data(data)
  let delta =
    list.zip(
      list.sort(list1, by: int.compare),
      list.sort(list2, by: int.compare),
    )
    |> list.map(fn(tuple) { int.absolute_value(tuple.0 - tuple.1) })
    |> list.fold(0, int.add)
  int.to_string(delta)
}

pub fn part2(data: String) -> String {
  let #(left, right) = parse_data(data)
  let right_counts = count_instances(right)

  list.map(left, fn(num) { num * unwrap(dict.get(right_counts, num), 0) })
  |> list.fold(0, int.add)
  |> int.to_string()
}

pub fn run() {
  let assert Ok(data) = simplifile.read("./data/01.txt")
  io.println(part1(data))
  io.println(part2(data))
}
