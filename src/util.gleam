import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/regexp
import gleam/set.{type Set}
import gleam/string

pub type Coord {
  Coord(row: Int, col: Int)
}

pub fn subtract_coords(c1: Coord, c2: Coord) {
  Coord(c1.row - c2.row, c1.col - c2.col)
}

pub fn add_coords(c1: Coord, c2: Coord) {
  Coord(c1.row + c2.row, c1.col + c2.col)
}

pub fn parse_number_lists(data: String) -> List(List(Int)) {
  let assert Ok(ws_re) = regexp.from_string(" +")

  string.split(data, on: "\n")
  |> list.filter(fn(x) { string.length(x) > 0 })
  |> list.map(fn(line) { regexp.split(with: ws_re, content: line) })
  |> list.map(fn(strings_of_nums: List(String)) {
    list.map(strings_of_nums, fn(num_str) {
      case int.parse(num_str) {
        Ok(x) -> x
        _ -> panic
      }
    })
  })
}

pub fn union_all(sets: List(Set(a))) -> Set(a) {
  case sets {
    [s1, ..rest] -> set.union(s1, union_all(rest))
    [] -> set.new()
  }
}

pub fn get_lines(data: String) -> List(String) {
  data
  |> string.split("\n")
  |> list.map(string.trim)
  |> list.filter(fn(x) { !string.is_empty(x) })
}

pub fn parse_int(str: String) -> Int {
  case int.parse(str) {
    Ok(val) -> val
    Error(Nil) -> {
      io.println("Failed to parse: " <> str)
      panic
    }
  }
}

pub fn get_at(l: List(value), idx: Int) -> Option(value) {
  case list.drop(l, idx) {
    [head, ..] -> Some(head)
    _ -> None
  }
}

pub fn index_of(l: List(value), v: value) -> Option(Int) {
  list.index_fold(l, None, fn(acc, x, idx) {
    case x == v {
      True -> Some(idx)
      False -> acc
    }
  })
}
