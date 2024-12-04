import gleam/int
import gleam/list
import gleam/regexp
import gleam/string

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
