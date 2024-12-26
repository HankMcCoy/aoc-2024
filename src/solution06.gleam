import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/result
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

type VisitedCoords =
  Dict(Coord, Set(Dir))

pub type GameState {
  GameState(
    guard_coord: Coord,
    guard_dir: Dir,
    visited: VisitedCoords,
    obstacles: Set(Coord),
    obstruction_coords: Set(Coord),
    bounds: Coord,
  )
}

fn add_visited(visited: VisitedCoords, coord: Coord, dir: Dir) -> VisitedCoords {
  dict.upsert(visited, coord, fn(prev_dirs) {
    case prev_dirs {
      None -> set.from_list([dir])
      Some(prev_dirs) -> set.insert(prev_dirs, dir)
    }
  })
}

fn has_visited(visited: VisitedCoords, coord: Coord, dir: Dir) {
  dict.get(visited, coord)
  |> result.try(fn(prev_dirs) { Ok(set.contains(prev_dirs, dir)) })
  |> result.unwrap(False)
}

pub fn parse_data(data: String) -> GameState {
  let lines = string.split(data, "\n")
  let game_state =
    GameState(
      guard_coord: Coord(0, 0),
      guard_dir: Up,
      visited: dict.new(),
      obstacles: set.new(),
      obstruction_coords: set.new(),
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
            visited: dict.from_list([#(coord, set.from_list([Up]))]),
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

pub type GameError {
  HasLoop
}

pub fn get_final_game_state(
  game_state: GameState,
) -> Result(GameState, GameError) {
  let candidate_coord = get_next_coord(game_state)
  let hit_obstacle = set.contains(game_state.obstacles, candidate_coord)
  let #(next_coord, next_dir) = case hit_obstacle {
    True -> #(game_state.guard_coord, rotate(game_state.guard_dir))
    False -> #(candidate_coord, game_state.guard_dir)
  }

  case
    is_out_of_bounds(next_coord, game_state.bounds),
    has_visited(game_state.visited, next_coord, next_dir)
  {
    // Went offscreen
    True, _ -> Ok(game_state)
    // Found a loop
    False, True -> {
      Error(HasLoop)
    }
    // Go to the next step
    False, False -> {
      get_final_game_state(
        GameState(
          ..game_state,
          guard_coord: next_coord,
          guard_dir: next_dir,
          visited: add_visited(game_state.visited, next_coord, next_dir),
        ),
      )
    }
  }
}

pub fn part1(game_state: GameState) -> String {
  let assert Ok(final_game_state) = get_final_game_state(game_state)
  dict.keys(final_game_state.visited)
  |> list.length()
  |> int.to_string()
}

pub fn part2(game_state: GameState) -> String {
  let assert Ok(final_state) = get_final_game_state(game_state)

  // Only bother looking at coordinates we crossed during the fist pass through
  dict.keys(final_state.visited)
  |> list.filter(fn(coord) {
    // Simulate running the whole thing from the top, with the new obstacle
    let simulation_result =
      get_final_game_state(
        GameState(
          ..game_state,
          obstacles: set.insert(game_state.obstacles, coord),
        ),
      )
    case simulation_result {
      Error(HasLoop) -> True
      _ -> False
    }
  })
  |> list.length
  |> int.to_string()
}

pub fn run() {
  let assert Ok(data) = simplifile.read("./data/06.txt")
  let initial_game_state = parse_data(data)

  io.println(part1(initial_game_state))
  io.println(part2(initial_game_state))
}
