import gleam/option.{None, Some}
import gleeunit/should
import util.{get_at, index_of}

pub fn get_at_test() {
  should.equal(get_at([10, 20, 30, 40], 0), Some(10))
  should.equal(get_at([10, 20, 30, 40], 1), Some(20))
  should.equal(get_at([10, 20, 30, 40], 2), Some(30))
  should.equal(get_at([10, 20, 30, 40], 3), Some(40))
  should.equal(get_at([10, 20, 30, 40], 4), None)
}

pub fn index_of_test() {
  should.equal(index_of([10, 20, 30, 40], 10), Some(0))
}
