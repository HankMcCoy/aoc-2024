import gleam/int
import gleam/io
import gleam/list
import gleam/set.{type Set}
import gleam/string
import simplifile
import util

pub fn parse_data(data: String) -> List(List(Int)) {
  let lines = string.split(data, "\n")

  list.map(lines, fn(line) {
    string.split(line, "")
    |> list.map(util.parse_int)
  })
}

type Coord {
  Coord(row: Int, col: Int)
}

type Grid =
  List(List(Int))

fn is_in_bounds(c: Coord, grid_size) -> Bool {
  case c {
    Coord(row, _) if row < 0 || row >= grid_size -> False
    Coord(_, col) if col < 0 || col >= grid_size -> False
    _ -> True
  }
}

fn get_neighbors(c: Coord, grid_size: Int) -> Set(Coord) {
  [
    Coord(c.row, c.col - 1),
    Coord(c.row, c.col + 1),
    Coord(c.row - 1, c.col),
    Coord(c.row + 1, c.col),
  ]
  |> list.filter(is_in_bounds(_, grid_size))
  |> set.from_list()
}

fn get_at_coord(grid: Grid, c: Coord) -> Int {
  let assert Ok(row) = list.drop(grid, c.row) |> list.first()
  let assert Ok(value) = list.drop(row, c.col) |> list.first()

  value
}

fn get_score_iter(
  grid: List(List(Int)),
  grid_size: Int,
  cur_height: Int,
  positions: Set(Coord),
) -> Int {
  let next_height = cur_height + 1
  let neighbors =
    set.to_list(positions)
    |> list.map(get_neighbors(_, grid_size))
    |> util.union_all()
    |> set.filter(fn(c) {
      case get_at_coord(grid, c) {
        height if height == next_height -> True
        _ -> False
      }
    })

  case next_height {
    9 -> set.size(neighbors)
    _ -> get_score_iter(grid, grid_size, next_height, neighbors)
  }
}

fn get_score(grid: List(List(Int)), coord: Coord) -> Int {
  get_score_iter(grid, list.length(grid), 0, set.from_list([coord]))
}

pub fn part1(data: String) -> String {
  let grid = parse_data(data)

  list.index_fold(grid, 0, fn(acc, row_data, row_idx) {
    list.index_fold(row_data, acc, fn(acc, height, col_idx) {
      case height {
        0 -> acc + get_score(grid, Coord(row_idx, col_idx))
        _ -> acc
      }
    })
  })
  |> int.to_string
}

pub fn part2(_data: String) -> String {
  ""
}

pub fn run() {
  let assert Ok(data) = simplifile.read("./data/10.txt")

  io.println(part1(data))
  io.println(part2(data))
}
