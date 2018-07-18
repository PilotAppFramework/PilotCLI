import Foundation
import Commander
import XcodeEdit
import PilotCLICore

Group {
    
    $0.command("install") {
        print("install this")
    }
    
    $0.command("upgrade") { (name:String) in
        print("Updating \(name)")
    }
    
    $0.command("make:env", description: "生成 环境配置文件", { (fileName:String) in
        let g = GenerateEnv()
        print(g.make() + " 环境文件 \(fileName)")
    })
    
    $0.command("search",
               Flag("web", description: "Searches on cocoapods.org"),
               Argument<String>("query"),
               Option("name", default: "w-orld"),
               description: "Perform a search"
    ) { web, query,name in
        if web {
            print("Searching for \(query) \(name)on the web.")
        } else {
            print("Locally searching for \(query) \(name).")
        }
    }
    
    }.run()
