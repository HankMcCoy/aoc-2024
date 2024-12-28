import ary
import gleam/option.{None, Some}
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn from_list_test() {
  let ar = ary.from_list([3, 8, 12, 33])

  should.equal(ary.get_at_safe(ar, 0), Ok(3))
  should.equal(ary.get_at_safe(ar, 1), Ok(8))
  should.equal(ary.get_at_safe(ar, 2), Ok(12))
  should.equal(ary.get_at_safe(ar, 3), Ok(33))
  should.equal(ary.get_at_safe(ar, 4), Error(Nil))
  should.equal(ary.size(ar), 4)
}

pub fn to_list_test() {
  should.equal(ary.to_list(ary.from_list([3, 8, 12])), [3, 8, 12])
  should.equal(ary.to_list(ary.new()), [])
}

pub fn first_index_of() {
  should.equal(ary.first_index_of(ary.from_list([1, 2, 3]), 4), None)
  should.equal(ary.first_index_of(ary.from_list([1, 2, 3]), 1), Some(0))
  should.equal(ary.first_index_of(ary.from_list([1, 2, 3]), 3), Some(2))
  should.equal(ary.first_index_of(ary.from_list([1, 1, 1]), 1), Some(0))
}

pub fn last_index_of() {
  should.equal(ary.last_index_of(ary.from_list([1, 2, 3]), 4), None)
  should.equal(ary.last_index_of(ary.from_list([1, 2, 3]), 1), Some(0))
  should.equal(ary.last_index_of(ary.from_list([1, 2, 3]), 3), Some(2))
  should.equal(ary.last_index_of(ary.from_list([1, 1, 1]), 1), Some(2))
}

pub fn swap_test() {
  should.equal(
    ary.swap(ary.from_list([1, 2, 3, 4]), 0, 3),
    ary.from_list([4, 2, 3, 1]),
  )
}

pub fn set_at_safe_test() {
  let ar = ary.from_list([3, 8, 12])

  should.equal(ary.set_at_safe(ar, 0, 4), Ok(ary.from_list([4, 8, 12])))
  should.equal(ary.set_at_safe(ar, 5, 4), Error(Nil))
}

pub fn map_test() {
  let ar = ary.from_list([1, 2, 3])

  should.equal(
    ary.map(ar, fn(x) {
      case x % 2 {
        0 -> "A"
        _ -> "B"
      }
    }),
    ary.from_list(["B", "A", "B"]),
  )
}

pub fn append_test() {
  let ar =
    ary.from_list([1, 2, 3])
    |> ary.append([4, 5, 6])

  should.equal(ary.get_at_safe(ar, 0), Ok(1))
  should.equal(ary.get_at_safe(ar, 1), Ok(2))
  should.equal(ary.get_at_safe(ar, 2), Ok(3))
  should.equal(ary.get_at_safe(ar, 3), Ok(4))
  should.equal(ary.get_at_safe(ar, 4), Ok(5))
  should.equal(ary.get_at_safe(ar, 5), Ok(6))
  should.equal(ary.get_at_safe(ar, 6), Error(Nil))
  should.equal(ary.size(ar), 6)
}
