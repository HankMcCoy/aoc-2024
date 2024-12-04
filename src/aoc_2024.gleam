import argv
import solution01
import solution02

pub fn main() {
  case argv.load().arguments {
    ["01"] -> solution01.run()
    ["02"] -> solution02.run()
    _ -> panic
  }
}
