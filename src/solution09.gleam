import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
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

pub fn get_file_at_block(disk_map: DiskMap, block_idx: Int) -> Option(Int) {
  case disk_map {
    [head, ..rest] -> {
      case head {
        FileBlock(size, id) if block_idx < size -> Some(id)
        Space(size) if block_idx < size -> None
        FileBlock(size, _) | Space(size) ->
          get_file_at_block(rest, block_idx - size)
      }
    }
    [] -> panic
  }
}

fn get_disk_map_size(disk_map: DiskMap) -> Int {
  disk_map
  |> list.map(fn(a) { a.size })
  |> int.sum()
}

pub fn part1(data: String) -> String {
  let disk_map = parse_data(data)
  let disk_map_size = get_disk_map_size(disk_map)

  list.range(0, disk_map_size - 1)
  |> list.map_fold(0, fn(nth_file_block_from_the_end, block_idx) {
    case get_file_at_block(disk_map, block_idx) {
      Some(file_id) -> #(nth_file_block_from_the_end, file_id)
      None -> {
        #(nth_file_block_from_the_end, todo)
        todo
      }
    }
  })
  |> fn(x) { x.1 }
  |> list.map(int.to_string)
  |> string.join("")
  ""
}

pub fn part2(_data: String) -> String {
  ""
}

pub fn run() {
  let assert Ok(data) = simplifile.read("./data/09.txt")

  io.println(part1(data))
  io.println(part2(data))
}
