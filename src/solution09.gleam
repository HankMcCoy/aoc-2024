import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/string
import simplifile
import util

pub type DiskMapUnit {
  Space(size: Int)
  FileBlock(size: Int, id: Int)
}

pub type DiskMap =
  List(DiskMapUnit)

pub fn parse_data(data: String) -> DiskMap {
  data
  |> string.split("")
  |> list.map(util.parse_int)
  |> list.index_map(fn(val, idx) {
    case idx % 2 {
      0 -> FileBlock(id: idx / 2, size: val)
      1 -> Space(val)
      _ -> panic
    }
  })
}

fn compress(disk_map: DiskMap) -> DiskMap {
  list.drop_while(disk_map, fn(unit) {
    case unit {
      Space(_) -> True
      _ -> False
    }
  })
}

// fn better_range(start: Int, stop_exclusive: Int) -> List(Int) {
//   case stop_exclusive - start {
//     0 -> []
//     delta if delta > 0 -> list.range(start, stop_exclusive - 1)
//     _ -> panic
//   }
// }

// fn render_disk_map(disk_map: DiskMap) -> String {
//   disk_map
//   |> list.map(fn(unit) {
//     case unit.size {
//       _ if unit.size < 0 -> panic
//       _ -> Nil
//     }
//     ""
//     <> better_range(0, unit.size)
//     |> list.map(fn(_) {
//       case unit {
//         FileBlock(_, id) -> int.to_string(id)
//         Space(_) -> "."
//       }
//     })
//     |> string.join("")
//     <> ""
//   })
//   |> string.join("")
// }

fn iterate1(disk_map: DiskMap) -> DiskMap {
  case disk_map {
    [head, ..rest] -> {
      let fill_stack = list.reverse(rest)
      case head {
        FileBlock(_, _) -> [head, ..iterate1(rest)]
        Space(empty_space) -> {
          case fill_stack {
            [FileBlock(fill_block_size, fill_block_id), ..rest_fill_stack] -> {
              let #(new_head, new_tail) = case empty_space - fill_block_size {
                delta if delta == 0 -> #(
                  [FileBlock(fill_block_size, fill_block_id)],
                  [],
                )
                // If there is more empty space than the size of the available fill block…
                delta if delta > 0 -> #(
                  // Take the entire fill block and create a new space block for the remaining space
                  [FileBlock(fill_block_size, fill_block_id), Space(delta)],
                  // Remove the fill block entirely
                  [],
                )
                // If the fill block is larger than the available space…
                delta -> #(
                  // Fill all the available space
                  [FileBlock(empty_space, fill_block_id)],
                  // Resize the fill_block
                  [FileBlock(-delta, fill_block_id)],
                )
              }

              [
                new_head,
                [new_tail, rest_fill_stack]
                  |> list.flatten()
                  |> compress()
                  |> list.reverse(),
              ]
              |> list.flatten()
              |> iterate1()
            }

            [Space(_), ..] -> panic
            _ -> disk_map
          }
        }
      }
    }
    [] -> []
  }
}

type Acc {
  Acc(idx_offset: Int, total: Int)
}

fn get_triangular_number(n: Int) {
  case n {
    -1 -> 0
    _ if n < 0 -> panic
    _ -> { n * { n + 1 } } / 2
  }
}

fn calculate_checksum(disk_map: DiskMap) -> Int {
  disk_map
  |> list.fold(Acc(idx_offset: 0, total: 0), fn(acc, unit) {
    let Acc(idx_offset, total) = acc
    case unit {
      FileBlock(size, id) -> {
        let block_total =
          id
          * {
            get_triangular_number(idx_offset + size - 1)
            - get_triangular_number(idx_offset - 1)
          }
        Acc(idx_offset: idx_offset + size, total: total + block_total)
      }
      Space(size) -> {
        Acc(idx_offset: idx_offset + size, total:)
      }
    }
  })
  |> fn(acc) { acc.total }
}

pub fn part1(data: String) -> String {
  let disk_map = parse_data(data)

  iterate1(disk_map)
  |> calculate_checksum()
  |> int.to_string()
}

pub fn part2(data: String) -> String {
  let disk_map = parse_data(data)

  let assert Ok(FileBlock(_, largest_file_id)) = list.last(disk_map)

  list.range(largest_file_id, 0)
  |> list.fold(disk_map, fn(dm, cur_file_id) {
    // Find the index of the current file
    let assert #(file_idx, Some(file)) =
      list.index_fold(dm, #(-1, None), fn(acc, unit, idx) {
        case unit {
          FileBlock(_, fid) if fid == cur_file_id -> #(idx, Some(unit))
          _ -> acc
        }
      })
    // Find the index (if any) of the first empty spot that can fit it
    let empty_spot_idx =
      list.index_fold(dm, -1, fn(acc, unit, idx) {
        case acc, unit {
          -1, Space(size) if size >= file.size -> idx
          _, _ -> acc
        }
      })

    case empty_spot_idx {
      -1 -> dm
      _ if empty_spot_idx >= file_idx -> dm
      _ ->
        // Map over the disk map, replacing the appropriate empty space with the file block, plus any leftover space
        list.index_map(dm, fn(unit, idx) {
          case idx, unit {
            _, FileBlock(_, _) if idx == file_idx -> [Space(file.size)]
            _, Space(empty_space) if idx == empty_spot_idx ->
              compress([file, Space(empty_space - file.size)])
            _, _ -> [unit]
          }
        })
        |> list.flatten()
    }
  })
  |> calculate_checksum()
  |> int.to_string()
}

pub fn run() {
  let assert Ok(data) = simplifile.read("./data/09.txt")

  io.println(part1(data))
  io.println(part2(data))
}
