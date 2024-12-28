import ary.{type Ary}
import gleam/function
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import simplifile
import util

pub type FileId =
  Int

pub type DiskMap =
  Ary(Option(FileId))

pub fn parse_data(data: String) -> DiskMap {
  let chars = string.split(data, "")
  let chars_len = list.length(chars)

  chars
  |> list.map(util.parse_int)
  |> list.index_fold(ary.new(), fn(ar, val, idx) {
    io.debug(
      "Parsing " <> int.to_string(idx) <> " of " <> int.to_string(chars_len),
    )
    let content = case idx % 2 {
      0 -> Some(idx / 2)
      _ -> None
    }

    case val {
      0 -> ar
      _ ->
        list.range(0, val - 1)
        |> list.map(fn(_) { content })
        |> ary.append(ar, _)
    }
  })
}

// fn debug_print(ar: DiskMap, idx: Int) {
//   let ar_str =
//     ar
//     |> ary.to_list()
//     |> list.map(fn(x) {
//       case x {
//         Some(val) -> int.to_string(val)
//         None -> "."
//       }
//     })
//     |> string.join("")
//   io.debug(ar_str)
// 
//   let ptr_str =
//     list.range(0, idx)
//     |> list.index_map(fn(_, i) {
//       case i {
//         i if i == idx -> "^"
//         _ -> " "
//       }
//     })
//     |> string.join("")
// 
//   io.debug(ptr_str)
// }

pub fn part1(data: String) -> String {
  io.debug("Parsing…")
  let ar = parse_data(data)
  io.debug("Folding…")
  ary.index_fold(ar, ar, fn(ar, val, idx) {
    io.debug("Idx: " <> int.to_string(idx))
    case val {
      Some(_) -> ar
      None -> {
        let last_non_empty_idx =
          ary.last_index_matching(ar, fn(val) {
            case val {
              Some(_) -> True
              _ -> False
            }
          })
        case last_non_empty_idx {
          Some(last_non_empty_idx) if idx < last_non_empty_idx ->
            ary.swap(ar, idx, last_non_empty_idx)
          _ -> ar
        }
      }
    }
  })
  |> ary.to_list()
  |> function.tap(fn(_) { io.debug("Calculating checksum…") })
  |> list.index_fold(0, fn(checksum, val, idx) {
    case val {
      Some(val) -> checksum + val * idx
      None -> checksum
    }
  })
  |> int.to_string()
}

pub fn part2(_data: String) -> String {
  ""
}

pub fn run() {
  let assert Ok(data) = simplifile.read("./data/09.txt")

  io.println(part1(data))
  io.println(part2(data))
}
