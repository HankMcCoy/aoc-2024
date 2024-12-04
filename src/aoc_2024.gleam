import argv
import solution01

pub fn main() {
  case argv.load().arguments {
    ["01"] -> solution01.run()
    _ -> panic
  }
}
