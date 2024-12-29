import argv
import solution01
import solution02
import solution03
import solution04
import solution05
import solution06
import solution07
import solution08
import solution09
import solution10

pub fn main() {
  case argv.load().arguments {
    ["01"] -> solution01.run()
    ["02"] -> solution02.run()
    ["03"] -> solution03.run()
    ["04"] -> solution04.run()
    ["05"] -> solution05.run()
    ["06"] -> solution06.run()
    ["07"] -> solution07.run()
    ["08"] -> solution08.run()
    ["09"] -> solution09.run()
    ["10"] -> solution10.run()
    _ -> panic as "No matching solution found"
  }
}
