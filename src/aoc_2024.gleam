import argv
import solution01
import solution02
import solution03
import solution04

pub fn main() {
  case argv.load().arguments {
    ["01"] -> solution01.run()
    ["02"] -> solution02.run()
    ["03"] -> solution03.run()
    ["04"] -> solution04.run()
    _ -> panic as "No matching solution found"
  }
}
