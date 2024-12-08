import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/regexp
import gleam/string
import simplifile

type SearchStrings {
  SearchStrings(
    horizontal: Dict(Int, String),
    vertical: Dict(Int, String),
    diagonal_lr: Dict(Int, String),
    diagonal_rl: Dict(Int, String),
  )
}

type Row =
  Int

type Col =
  Int

type Coord {
  Coord(row: Row, col: Col)
}

fn get_coord(index: Int, line_length: Int) -> Coord {
  let assert Ok(row) = int.divide(index, line_length + 1)
  let assert Ok(col) = int.modulo(index, line_length + 1)

  Coord(row:, col:)
}

fn get_search_strings(data: String) -> List(String) {
  let line_length = case string.split_once(data, "\n") {
    Ok(#(first_line, _)) -> string.length(first_line)
    _ -> panic
  }
  let chars = string.split(data, "")

  let search_strings =
    chars
    |> list.index_fold(
      from: SearchStrings(
        horizontal: dict.new(),
        vertical: dict.new(),
        diagonal_lr: dict.new(),
        diagonal_rl: dict.new(),
      ),
      with: fn(acc, char, index) {
        let coord = get_coord(index, line_length)

        case char {
          "\n" -> acc
          _ ->
            SearchStrings(
              horizontal: dict.upsert(acc.horizontal, coord.row, fn(val) {
                option.unwrap(val, "") <> char
              }),
              vertical: dict.upsert(acc.vertical, coord.col, fn(val) {
                option.unwrap(val, "") <> char
              }),
              diagonal_lr: dict.upsert(
                acc.diagonal_lr,
                coord.row - coord.col,
                fn(val) { option.unwrap(val, "") <> char },
              ),
              diagonal_rl: dict.upsert(
                acc.diagonal_rl,
                coord.row + coord.col,
                fn(val) { option.unwrap(val, "") <> char },
              ),
            )
        }
      },
    )

  list.flatten([
    dict.values(search_strings.diagonal_lr),
    dict.values(search_strings.diagonal_rl),
    dict.values(search_strings.horizontal),
    dict.values(search_strings.vertical),
  ])
}

pub fn part1(data: String) -> String {
  let search_strings = get_search_strings(data)
  let assert Ok(xmas_re) = regexp.from_string("XMAS")
  let assert Ok(smax_re) = regexp.from_string("SAMX")

  // For each string, count how many times XMAS and SAMX show up
  search_strings
  |> list.map(fn(x) {
    list.length(regexp.scan(with: xmas_re, content: x))
    + list.length(regexp.scan(with: smax_re, content: x))
  })
  |> int.sum
  |> int.to_string
}

fn parse_cells_by_coord(data: String) -> Dict(Coord, String) {
  let line_length = case string.split_once(data, "\n") {
    Ok(#(first_line, _)) -> string.length(first_line)
    _ -> panic
  }
  let chars = string.split(data, "")

  list.index_fold(over: chars, from: dict.new(), with: fn(acc, char, index) {
    let coord = get_coord(index, line_length)
    dict.insert(into: acc, for: coord, insert: char)
  })
}

type Triplet =
  #(Result(String, Nil), Result(String, Nil), Result(String, Nil))

fn is_triplet_mas(triplet: Triplet) -> Bool {
  let str = case triplet {
    #(Ok(s1), Ok(s2), Ok(s3)) -> Ok(s1 <> s2 <> s3)
    _ -> Error(Nil)
  }

  case str {
    Ok(str) -> str == "MAS" || str == "SAM"
    _ -> False
  }
}

pub fn part2(data: String) -> String {
  let cells_by_coord = parse_cells_by_coord(data)
  cells_by_coord
  |> dict.fold(from: 0, with: fn(acc, coord, _char) {
    let diag_lr_triplet = #(
      dict.get(cells_by_coord, Coord(row: coord.row - 1, col: coord.col - 1)),
      dict.get(cells_by_coord, Coord(row: coord.row, col: coord.col)),
      dict.get(cells_by_coord, Coord(row: coord.row + 1, col: coord.col + 1)),
    )
    let diag_rl_triplet = #(
      dict.get(cells_by_coord, Coord(row: coord.row - 1, col: coord.col + 1)),
      dict.get(cells_by_coord, Coord(row: coord.row, col: coord.col)),
      dict.get(cells_by_coord, Coord(row: coord.row + 1, col: coord.col - 1)),
    )
    case is_triplet_mas(diag_lr_triplet) && is_triplet_mas(diag_rl_triplet) {
      True -> {
        acc + 1
      }
      False -> acc
    }
  })
  |> int.to_string
}

pub fn run() {
  let assert Ok(data) = simplifile.read("./data/04.txt")
  io.println(part1(data))
  io.println(part2(data))
}
