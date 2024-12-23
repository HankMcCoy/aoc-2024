import gleam/erlang/process
import gleam/int
import gleam/io
import gleam/list
import gleam/set.{type Set}
import gleam/string
import simplifile

pub type Coord {
  Coord(row: Int, col: Int)
}

pub type Dir {
  Left
  Up
  Right
  Down
}

pub type GameState {
  GameState(
    guard_coord: Coord,
    guard_dir: Dir,
    visited: Set(Coord),
    obstacles: Set(Coord),
    bounds: Coord,
  )
}

pub fn parse_data(data: String) -> GameState {
  let lines = string.split(data, "\n")
  let game_state =
    GameState(
      guard_coord: Coord(0, 0),
      guard_dir: Up,
      visited: set.new(),
      obstacles: set.new(),
      bounds: Coord(0, 0),
    )
  list.index_fold(lines, game_state, fn(game_state, line, row) {
    let cells = string.split(line, "")
    list.index_fold(cells, game_state, fn(game_state, cell, col) {
      let coord = Coord(row:, col:)
      let game_state =
        GameState(
          ..game_state,
          bounds: Coord(
            int.max(row, game_state.bounds.row),
            int.max(col, game_state.bounds.col),
          ),
        )
      case cell {
        "^" ->
          GameState(
            ..game_state,
            guard_coord: coord,
            visited: set.from_list([coord]),
          )
        "#" ->
          GameState(
            ..game_state,
            obstacles: set.insert(game_state.obstacles, coord),
          )
        _ -> game_state
      }
    })
  })
}

pub fn get_next_coord(game_state: GameState) -> Coord {
  let coord = game_state.guard_coord
  case game_state.guard_dir {
    Left -> Coord(..coord, col: coord.col - 1)
    Up -> Coord(..coord, row: coord.row - 1)
    Right -> Coord(..coord, col: coord.col + 1)
    Down -> Coord(..coord, row: coord.row + 1)
  }
}

pub fn rotate(dir: Dir) -> Dir {
  case dir {
    Left -> Up
    Up -> Right
    Right -> Down
    Down -> Left
  }
}

pub fn is_out_of_bounds(coord: Coord, bounds: Coord) -> Bool {
  case coord {
    Coord(row, _) if row < 0 || row > bounds.row -> True
    Coord(_, col) if col < 0 || col > bounds.col -> True
    _ -> False
  }
}

pub fn render_game_state(game_state: GameState) -> String {
  list.range(0, game_state.bounds.row)
  |> list.map(fn(row) {
    list.range(0, game_state.bounds.col)
    |> list.map(fn(col) {
      let coord = Coord(row, col)
      case set.contains(game_state.obstacles, coord), coord {
        True, _ -> {
          "#"
        }
        False, coord if coord == game_state.guard_coord -> {
          case game_state.guard_dir {
            Up -> "^"
            Right -> ">"
            Down -> "|"
            Left -> "<"
          }
        }
        _, _ -> "."
      }
    })
    |> string.join("")
  })
  |> string.join("\n")
}

//fn print_game_state(game_state: GameState) {
//  // Clear the screen
//  list.range(0, 130)
//  |> list.each(fn(_) { io.println("") })
//
//  // Print the screen
//  io.print(render_game_state(game_state))
//
//  // Wait a bit
//  process.sleep(100)
//}

pub fn calculate_visits(game_state: GameState) -> Int {
  // Do stuff
  let candidate_coord = get_next_coord(game_state)
  let hit_obstacle = set.contains(game_state.obstacles, candidate_coord)
  let went_offscreen = is_out_of_bounds(candidate_coord, game_state.bounds)
  case went_offscreen, hit_obstacle {
    True, _ -> set.size(game_state.visited)
    False, True ->
      calculate_visits(
        GameState(..game_state, guard_dir: rotate(game_state.guard_dir)),
      )
    False, False ->
      calculate_visits(
        GameState(
          ..game_state,
          guard_coord: candidate_coord,
          visited: set.insert(game_state.visited, candidate_coord),
        ),
      )
  }
}

pub fn part1(data: String) -> String {
  let game_state = parse_data(data)

  game_state
  |> calculate_visits
  |> int.to_string
}

pub fn part2(_data: String) -> String {
  ""
}

pub fn run() {
  let assert Ok(data) = simplifile.read("./data/06.txt")
  io.println(part1(data))
  io.println(part2(data))
}
