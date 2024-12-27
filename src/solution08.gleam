import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/set.{type Set}
import gleam/string
import simplifile
import util.{type Coord, Coord}

type Antenna =
  String

pub type ParsedData {
  ParsedData(antennas: Dict(Antenna, List(Coord)), size: Int)
}

pub fn parse_data(data: String) -> ParsedData {
  let lines = util.get_lines(data)

  let antennas =
    list.index_fold(lines, dict.new(), fn(acc, line, row) {
      string.split(line, "")
      |> list.index_fold(acc, fn(acc, cell, col) {
        case cell {
          "." -> acc
          antenna ->
            dict.upsert(acc, antenna, fn(cur_value) {
              case cur_value {
                Some(cur_value) -> list.append(cur_value, [Coord(row, col)])
                None -> [Coord(row, col)]
              }
            })
        }
      })
    })

  ParsedData(antennas:, size: list.length(lines))
}

fn is_in_bounds(c: Coord, size: Int) {
  case c {
    Coord(row, _) if row < 0 || row >= size -> False
    Coord(_, col) if col < 0 || col >= size -> False
    _ -> True
  }
}

pub fn get_antinodes_by_antenna(
  parsed_data: ParsedData,
  get_candidate_antinodes: fn(#(Coord, Coord), Int) -> Set(Coord),
) -> Dict(Antenna, Set(Coord)) {
  parsed_data.antennas
  |> dict.map_values(fn(_antenna, coords) { list.combination_pairs(coords) })
  |> dict.map_values(fn(_antenna, coord_pairs) {
    list.map(coord_pairs, get_candidate_antinodes(_, parsed_data.size))
    |> util.union_all()
  })
}

pub fn get_candidate_antinodes_v1(coord_pair: #(Coord, Coord), size: Int) {
  let #(c1, c2) = coord_pair
  [
    util.add_coords(c1, util.subtract_coords(c1, c2)),
    util.add_coords(c2, util.subtract_coords(c2, c1)),
  ]
  |> list.filter(is_in_bounds(_, size))
  |> set.from_list()
}

pub fn part1(data: String) -> String {
  let parsed_data = parse_data(data)
  get_antinodes_by_antenna(parsed_data, get_candidate_antinodes_v1)
  |> dict.values()
  |> util.union_all()
  |> set.size()
  |> int.to_string()
}

fn apply_delta_until_out_of_bounds(
  start_coord: Coord,
  delta: Coord,
  size: Int,
) -> List(Coord) {
  let next_coord = util.add_coords(start_coord, delta)
  case is_in_bounds(next_coord, size) {
    True -> [
      next_coord,
      ..apply_delta_until_out_of_bounds(next_coord, delta, size)
    ]
    False -> []
  }
}

pub fn get_candidate_antinodes_v2(coord_pair: #(Coord, Coord), size: Int) {
  let #(c1, c2) = coord_pair
  [
    apply_delta_until_out_of_bounds(c2, util.subtract_coords(c1, c2), size),
    apply_delta_until_out_of_bounds(c1, util.subtract_coords(c2, c1), size),
  ]
  |> list.flatten()
  |> list.filter(is_in_bounds(_, size))
  |> set.from_list()
}

pub fn part2(data: String) -> String {
  let parsed_data = parse_data(data)
  get_antinodes_by_antenna(parsed_data, get_candidate_antinodes_v2)
  |> dict.values()
  |> util.union_all()
  |> set.size()
  |> int.to_string()
}

pub fn run() {
  let assert Ok(data) = simplifile.read("./data/08.txt")

  io.println(part1(data))
  io.println(part2(data))
}
