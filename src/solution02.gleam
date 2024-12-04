import gleam/int
import gleam/io
import gleam/list
import simplifile
import util

type Dir {
  Asc
  Desc
}

fn is_safe_delta(a: Int, b: Int, dir: Dir) -> Bool {
  let delta = b - a
  case delta, dir {
    delta, Asc if delta >= 1 && delta <= 3 -> True
    delta, Desc if delta <= -1 && delta >= -3 -> True
    _, _ -> False
  }
}

fn is_report_safe_cont(report: List(Int), dir: Dir) -> Bool {
  case report {
    [first, second, ..rest] -> {
      case is_safe_delta(first, second, dir) {
        True -> is_report_safe_cont([second, ..rest], dir)
        False -> False
      }
    }
    _ -> True
  }
}

fn is_report_safe(report: List(Int)) -> Bool {
  case report {
    [first, second, ..] -> {
      let delta = second - first
      case delta {
        delta if delta > 0 -> is_report_safe_cont(report, Asc)
        delta if delta < 0 -> is_report_safe_cont(report, Desc)
        _ -> False
      }
    }
    _ -> True
  }
}

pub fn parse_data(data: String) -> List(List(Int)) {
  util.parse_number_lists(data)
}

pub fn part1(data: String) -> String {
  let reports = parse_data(data)
  int.to_string(list.count(reports, where: is_report_safe))
}

pub fn part2(data: String) -> String {
  let reports = parse_data(data)
  int.to_string(
    list.count(reports, where: fn(report) {
      let report_possibilities = [
        report,
        ..list.combinations(report, list.length(report) - 1)
      ]
      list.any(report_possibilities, is_report_safe)
    }),
  )
}

pub fn run() {
  let assert Ok(data) = simplifile.read("./data/02.txt")
  io.println(part1(data))
  io.println(part2(data))
}
