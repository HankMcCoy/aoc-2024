import gleam/dict.{type Dict}
import gleam/int
import gleam/list.{Continue, Stop}
import gleam/option.{type Option, None, Some}

pub opaque type Ary(a) {
  Ary(content: Dict(Int, a), size: Int)
}

pub type AryError {
  InvalidIndex
}

fn get_idxs(size: Int) {
  case size {
    0 -> []
    _ -> list.range(0, size - 1)
  }
}

pub fn new() {
  Ary(dict.new(), 0)
}

pub fn from_list(elements: List(a)) -> Ary(a) {
  Ary(
    elements
      |> list.index_map(fn(element, idx) { #(idx, element) })
      |> dict.from_list(),
    list.length(elements),
  )
}

pub fn to_list(ary: Ary(a)) -> List(a) {
  get_idxs(ary.size)
  |> list.sort(int.compare)
  |> list.map(fn(key) {
    case dict.get(ary.content, key) {
      Ok(val) -> val
      _ -> panic
    }
  })
}

pub fn get_at(ar: Ary(a), idx: Int) -> a {
  case get_at_safe(ar, idx) {
    Ok(element) -> element
    Error(Nil) -> panic
  }
}

pub fn get_at_safe(ar: Ary(a), idx: Int) -> Result(a, Nil) {
  dict.get(ar.content, idx)
}

pub fn set_at(ar: Ary(a), idx: Int, value: a) -> Ary(a) {
  case set_at_safe(ar, idx, value) {
    Ok(updated_ar) -> updated_ar
    Error(Nil) -> panic
  }
}

pub fn set_at_safe(ar: Ary(a), idx: Int, value: a) -> Result(Ary(a), Nil) {
  case dict.get(ar.content, idx) {
    Error(Nil) -> Error(Nil)
    Ok(_) ->
      Ok(Ary(content: dict.insert(ar.content, idx, value), size: ar.size))
  }
}

pub fn map(ar: Ary(a), map_fn: fn(a) -> b) -> Ary(b) {
  Ary(
    content: get_idxs(ar.size)
      |> list.map(fn(idx) { #(idx, map_fn(get_at(ar, idx))) })
      |> dict.from_list(),
    size: ar.size,
  )
}

pub fn filter(ar: Ary(a), predicate_fn: fn(a) -> Bool) -> Ary(a) {
  to_list(ar)
  |> list.filter(predicate_fn)
  |> from_list()
}

pub fn index_fold(
  over ar: Ary(a),
  from initial: b,
  with fun: fn(b, a, Int) -> b,
) -> b {
  get_idxs(ar.size)
  |> list.fold(initial, fn(acc, idx) { fun(acc, get_at(ar, idx), idx) })
}

pub fn fold(over ar: Ary(a), from initial: b, with fun: fn(b, a) -> b) -> b {
  get_idxs(ar.size)
  |> list.fold(initial, fn(acc, idx) { fun(acc, get_at(ar, idx)) })
}

pub fn size(ar: Ary(a)) -> Int {
  ar.size
}

pub fn first_index_of(ar: Ary(a), target: a) -> Option(Int) {
  first_index_matching(ar, fn(x) { x == target })
}

pub fn last_index_of(ar: Ary(a), target: a) -> Option(Int) {
  last_index_matching(ar, fn(x) { x == target })
}

pub fn first_index_matching(
  ar: Ary(a),
  predicate_fn: fn(a) -> Bool,
) -> Option(Int) {
  get_idxs(ar.size)
  |> list.fold_until(None, fn(acc, idx) {
    case predicate_fn(get_at(ar, idx)) {
      True -> Stop(Some(idx))
      False -> Continue(acc)
    }
  })
}

pub fn last_index_matching(
  ar: Ary(a),
  predicate_fn: fn(a) -> Bool,
) -> Option(Int) {
  get_idxs(ar.size)
  |> list.reverse()
  |> list.fold_until(None, fn(acc, idx) {
    case predicate_fn(get_at(ar, idx)) {
      True -> Stop(Some(idx))
      False -> Continue(acc)
    }
  })
}

pub fn swap(ar: Ary(a), idx1: Int, idx2: Int) -> Ary(a) {
  let val1 = get_at(ar, idx1)
  let val2 = get_at(ar, idx2)
  ar
  |> set_at(idx1, val2)
  |> set_at(idx2, val1)
}

pub fn append(ar: Ary(a), elements: List(a)) -> Ary(a) {
  Ary(
    content: dict.combine(
      ar.content,
      elements
        |> list.index_map(fn(el, idx) { #(idx + ar.size, el) })
        |> dict.from_list(),
      fn(_a, _b) {
        // These two dictionaries should _never_ have any overlap in indices.
        panic
      },
    ),
    size: ar.size + list.length(elements),
  )
}
