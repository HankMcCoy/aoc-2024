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

pub fn causes_loop(game_state: GameState) -> Bool {
  let next_coord = get_next_coord(game_state)
  let hit_obstacle = set.contains(game_state.obstacles, next_coord)
  let went_offscreen = is_out_of_bounds(next_coord, game_state.bounds)

  !went_offscreen
  && case hit_obstacle {
    True -> {
      let new_dir = rotate(game_state.guard_dir)
      causes_loop(
        GameState(
          ..game_state,
          guard_dir: new_dir,
          visited: add_visited(
            game_state.visited,
            game_state.guard_coord,
            new_dir,
          ),
        ),
      )
    }
    False -> {
      has_visited(game_state.visited, next_coord, game_state.guard_dir)
      || causes_loop(
        GameState(
          ..game_state,
          guard_coord: next_coord,
          visited: add_visited(
            game_state.visited,
            next_coord,
            game_state.guard_dir,
          ),
        ),
      )
    }
  }
}

pub fn get_final_game_state(game_state: GameState) -> GameState {
  let next_coord = get_next_coord(game_state)
  let hit_obstacle = set.contains(game_state.obstacles, next_coord)
  let went_offscreen = is_out_of_bounds(next_coord, game_state.bounds)
  case went_offscreen, hit_obstacle {
    // Went offscreen
    True, _ -> game_state
    // Hit an obstacle, turn right
    False, True -> {
      let new_dir = rotate(game_state.guard_dir)
      get_final_game_state(
        GameState(
          ..game_state,
          guard_dir: new_dir,
          // While we have already visited this square, we need to 
          visited: add_visited(
            game_state.visited,
            game_state.guard_coord,
            new_dir,
          ),
        ),
      )
    }
    // Keep going straight
    False, False -> {
      let is_viable_obstruction_coord = {
        let new_dir = rotate(game_state.guard_dir)
        causes_loop(
          GameState(
            ..game_state,
            obstacles: set.insert(game_state.obstacles, next_coord),
            guard_dir: new_dir,
            visited: add_visited(
              game_state.visited,
              game_state.guard_coord,
              new_dir,
            ),
          ),
        )
      }
      get_final_game_state(
        GameState(
          ..game_state,
          guard_coord: next_coord,
          visited: add_visited(
            game_state.visited,
            next_coord,
            game_state.guard_dir,
          ),
          // Check if turning here _would_ have created a loop
          obstruction_coords: case is_viable_obstruction_coord {
            True -> set.insert(game_state.obstruction_coords, next_coord)
            False -> game_state.obstruction_coords
          },
        ),
      )
    }
  }
}

pub fn part1(game_state: GameState) -> String {
  game_state
  |> fn(state) { dict.keys(state.visited) }
  |> list.length()
  |> int.to_string()
}

pub fn part2(game_state: GameState) -> String {
  game_state
  |> fn(state) { set.size(state.obstruction_coords) }
  |> int.to_string()
}

pub fn run() {
  let assert Ok(data) = simplifile.read("./data/06.txt")
  let final_game_state = get_final_game_state(parse_data(data))

  io.println(part1(final_game_state))
  io.println(part2(final_game_state))
}
